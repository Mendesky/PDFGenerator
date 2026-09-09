# Classic PDF 標註留言附錄 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development（推薦）或 superpowers:executing-plans 逐 Task 執行。Steps 用 checkbox（`- [ ]`）追蹤。

**Goal:** Classic 訪談表 PDF 第二頁尾部新增「組內留言」「標註留言」兩個附錄表格區塊，並確認既有 markdown 渲染管線能承載 highlight 編號上標（`<sup>[n]</sup>`）。本 plan 只做**渲染**，資料型別以 fixture 直接建構，不依賴 `AnnotatingAggregate`（那是 HandoverDocumentViewContext 那份 plan 的範圍）。

**Architecture:** 沿用 `ClassicFormPage2.Section`/`Row` 既有的「通用資料模型＋`cellGroups(for row:)` switch 渲染」架構（比照 `.quoting`/`QuotingGroup` 結構化資料的既有 pattern，而非塞一段 markdown 字串了事）。新增兩個 `Row.Kind`：`.groupThread`（組內留言，無需編號/引文）與 `.annotationHighlight`（標註留言，編號徽章＋標註者/時間＋引文＋留言串）。呼叫端（HandoverDocumentViewContext）組好 `Section(label: "組內留言", rows: [...])` / `Section(label: "標註留言", rows: [...])` 兩個 Section，append 進現有 `page2Sections` 陣列即可，`ClassicHandoverDocument`/`ClassicFormPage2` 本身完全不用改。

**Tech Stack:** Swift 6 / Plot（HTML DSL）/ swift-markdown（`MarkdownHTML.render`）/ Swift Testing

**Spec:** `/Volumes/Development/HandoverDocumentViewContext/.claude/worktrees/interview-annotation-pdf-appendix-design/docs/superpowers/specs/2026-09-09-interview-annotation-pdf-appendix-design.md`（設計討論在 HandoverDocumentViewContext repo；本 plan 是其中「PDFGenerator 渲染」子系統的落地）

## Global Constraints

- Repo：`PDFGenerator`，worktree `.claude/worktrees/interview-annotation-appendix`，branch `feat/interview-annotation-appendix`
- **禁 bulk staging**（`git add -A` / `commit -a`）—— 逐檔 `git add`
- Commit tag：本 repo 觀察到的慣例含 `[ADD]`/`[FIX]`/`[UPDATE]`/`[CHANGE]`；新增全新能力一律用 `[ADD]`
- 測試框架是 **Swift Testing**（`import Testing`），不是 XCTest；測試檔頂層直接寫 `@Test func`，不包 `struct`（比照 `Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift` 現況）
- 跑測試：`set -o pipefail; swift test --filter <TestName> 2>&1 | tail -60`（這個 repo 沒有 `scripts/run-tests.sh`，但本機 hook 會擋沒加 `pipefail` 的 `swift test`，記得每次都加）
- 本 repo 目前 commit message **沒有** `Co-Authored-By` 慣例，但本次任務的外部指示要求所有 commit 加上：
  ```
  Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
  ```
  每個 Task 的 commit 都照加。
- 最後一個 Task 完成後需 push 一個新 semver tag（目前最新 `1.31.0`，本次功能不含 breaking change，打 `1.32.0`）——`HandoverDocumentViewContext` 的 `Package.swift` 用 `from: "1.28.12"` floor pin 依賴本 repo，新 tag push 後對方 `swift package update` 即可撿到，不需改對方 `Package.swift`。

## Self-Review 紀錄（寫 plan 時先做過一輪，供執行者參考）

**Spec 覆蓋檢查**（對照設計 spec「詳細設計」章節）：

| Spec 項目 | 對應 Task |
|---|---|
| 內文標記插入 `<sup>[n]</sup>` 不印底色 | Task 1（驗證 markdown inline HTML passthrough，插入本身由 HDV 那份 plan 做） |
| 第二頁尾部「組內留言」附錄 | Task 2 |
| 第二頁尾部「標註留言」附錄（編號方框／標註者時間／引文／留言串／無留言／位置無法定位） | Task 3 |
| 定位失敗仍列出、標「位置無法定位」、不加方框 | Task 3（`isPositioned: false` 分支） |

**刻意的設計選擇**：
- 兩個新 Row.Kind 承載**結構化資料**（`AnnotationHighlight`/`AnnotationThread`/`AnnotationMessage`），不是塞一段 HTML/markdown 字串——比照既有 `.quoting`/`QuotingGroup` 的做法，讓 PDFGenerator 保留對自己 markup／CSS 的完整控制權，呼叫端不需要知道任何 CSS class 名稱。也因此留言內容（使用者輸入，非本系統產生）一律用 Plot 的 `Div("plain string")`/`Span("plain string")` escape 過的建構子渲染，**不用** `Div(html:)` 原樣注入，避免使用者留言內容裡的 `<`/`>` 破壞版面或造成注入。
- 每個 highlight／thread 各自是**獨立一個 Row**（而非整個附錄塞一個 Row），沿用 `flatSection` 既有的「第一列帶 rowspan 區塊標籤」機制，讓「組內留言」「標註留言」這兩個字直接複用 `ClassicVerticalLabel` 的直書標籤渲染，不用額外寫版面邏輯。

---

## Task 1: 驗證 markdown inline raw HTML passthrough（不印底色的技術前提）

**Files:**
- Test: `Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift`（在檔尾新增，不建新檔——這支已經是 markdown 渲染相關斷言的既有集中地，見同檔 `interviewInfoSectionRendersMarkdown` 等測試）

**Interfaces:**
- Consumes：既有 `MarkdownHTML.render(_ markdown: String) -> String`（`Sources/HandoverDocumentHTML/MarkdownHTML.swift`，package-internal，測試檔用 `@testable import HandoverDocumentHTML` 可直接呼叫）、既有 `ClassicFormPage2.Row.markdown(_:_:)`
- Produces：無新產出，純驗證既有行為，供後續 Task 2/3 及 HandoverDocumentViewContext 那份 plan 安心依賴

> **背景**：這是設計 spec 列的「開放風險 #3」。已經手動驗證過一次（`MarkdownHTML.render("毛利率略有下滑<sup>[2]</sup>，惟仍在可控範圍。")` 輸出 `<p>毛利率略有下滑<sup>[2]</sup>，惟仍在可控範圍。</p>`，`<sup>` 未被跳脫），本 Task 是把這個驗證正式寫成回歸測試，鎖住這個假設。

- [ ] **Step 1: 寫測試**

```swift
@Test func markdownRenderPassesThroughInlineSupTag() {
    // highlight 編號上標插入點在 markdown 原文字串裡，須確認 swift-markdown 不會把 <sup> 轉義成 &lt;sup&gt;
    let markdown = "毛利率略有下滑<sup>[2]</sup>，惟仍在可控範圍。"
    let html = MarkdownHTML.render(markdown)
    #expect(html.contains("<sup>[2]</sup>"))
    #expect(!html.contains("&lt;sup&gt;"))
}

@Test func classicFormPage2MarkdownRowPreservesInlineSupTag() {
    // 同一件事，走實際會用到的路徑（.markdown row → ClassicFormPage2 渲染），不只測 MarkdownHTML 本身
    let doc = ClassicHandoverDocument(
        page1: .init(companyName: "範例股份有限公司"),
        page2Sections: [
            .init(label: "訪談紀錄", rows: [.markdown("客戶營運現況", "毛利率略有下滑<sup>[2]</sup>，惟仍在可控範圍。")]),
        ]
    )
    let html = doc.render()
    #expect(html.contains("<sup>[2]</sup>"))
}
```

- [ ] **Step 2: 執行測試確認通過**

Run: `set -o pipefail; swift test --filter markdownRenderPassesThroughInlineSupTag 2>&1 | tail -40`
Run: `set -o pipefail; swift test --filter classicFormPage2MarkdownRowPreservesInlineSupTag 2>&1 | tail -40`
Expected: 兩支都 PASS（這是鎖住既有正確行為，不是紅燈開始）

- [ ] **Step 3: Commit**

```bash
git add Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift
git commit -m "$(cat <<'EOF'
[ADD] 回歸測試：鎖住 markdown inline <sup> passthrough 行為

訪談表標註留言附錄功能需要在段落文字裡插入 <sup>[n]</sup> 上標，
先鎖住 swift-markdown 不會把它跳脫轉義的既有行為。

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: 新增「組內留言」附錄（`ClassicFormPage2.Row.groupThread`）

**Files:**
- Modify: `Sources/HandoverDocumentHTML/Classic/ClassicFormPage2.swift`
- Modify: `Sources/HandoverDocumentHTML/Classic/ClassicStylesheet.swift`
- Test: `Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift`

**Interfaces:**
- Consumes：無新外部依賴
- Produces：
  - `public struct ClassicFormPage2.AnnotationMessage { authorName: String; postedAt: String; content: String; isReply: Bool }`（`postedAt` 已是呼叫端格式化好的字串，如 `"2026/08/12 10:15"`；`isReply: true` 時往內縮排一階渲染）
  - `public struct ClassicFormPage2.AnnotationThread { messages: [AnnotationMessage] }`
  - `public static func ClassicFormPage2.Row.groupThread(_ thread: AnnotationThread) -> Row`
  - 私有 helper `annotationThreadBody(_ messages: [AnnotationMessage]) -> Component`（Task 3 會複用）

> **模式參照**：`Row.Kind` 目前是 `enum Kind { case field, markdown, heading, full, pairs, quoting }`，`Row` struct 用 5 個 stored property（`kind`/`label`/`value`/`pairs`/`quoting`）+ 對應 static factory，`cellGroups(for row:)` 用 switch 分派、`.quoting` 走 `guard let group else { return [] }` 的安全空陣列 fallback（**不是 force-unwrap**——本 repo 禁止 `!` force-unwrap）。新增 kind 照抄同一套骨架：加 stored property＋factory＋switch case，一致的 guard-else-empty-array fallback。

- [ ] **Step 1: 寫失敗測試**

```swift
@Test func classicPage2RendersGroupThreadWithReplyIndent() {
    let doc = ClassicHandoverDocument(
        page1: .init(companyName: "範例股份有限公司"),
        page2Sections: [
            .init(label: "組內留言", rows: [
                .groupThread(.init(messages: [
                    .init(authorName: "林志豪", postedAt: "2026/08/11 17:05", content: "這份訪談表整體資料齊全，建議下週提交複核。", isReply: false),
                    .init(authorName: "陳雅婷", postedAt: "2026/08/11 17:40", content: "收到，我這邊會再補一份財務報表附件。", isReply: true),
                ]))
            ])
        ]
    )
    let html = doc.render()
    #expect(html.contains("組內留言"))
    #expect(html.contains("林志豪"))
    #expect(html.contains("2026/08/11 17:05"))
    #expect(html.contains("這份訪談表整體資料齊全"))
    #expect(html.contains("annotationReply"))
    // 使用者輸入內容須被 escape，不可原樣注入（防呆：含 < 的內容不應破壞結構）
    let index = html.range(of: "林志豪")!.lowerBound
    #expect(html.distance(from: html.startIndex, to: index) > 0)
}

@Test func classicPage2RendersGroupThreadEmptyMessagesAsNoComment() {
    let doc = ClassicHandoverDocument(
        page1: .init(companyName: "範例股份有限公司"),
        page2Sections: [
            .init(label: "組內留言", rows: [.groupThread(.init(messages: []))])
        ]
    )
    let html = doc.render()
    #expect(html.contains("無留言"))
}
```

- [ ] **Step 2: 執行測試確認失敗**

Run: `set -o pipefail; swift test --filter classicPage2RendersGroupThread 2>&1 | tail -60`
Expected: 編譯失敗（`AnnotationThread`/`AnnotationMessage`/`.groupThread` 尚未定義）

- [ ] **Step 3: 實作**

修改 `Sources/HandoverDocumentHTML/Classic/ClassicFormPage2.swift`，把 `enum Kind` 那一行與 `Row` 的 6 個 static factory 整段換掉：

```swift
    public struct Row {
        enum Kind { case field, markdown, heading, full, pairs, quoting, groupThread, annotationHighlight }
        let kind: Kind
        let label: String?
        let value: String
        let pairs: [(String, String)]
        let quoting: QuotingGroup?
        let groupThread: AnnotationThread?
        let annotationHighlight: AnnotationHighlight?

        /// label｜value 一般欄位
        public static func field(_ label: String, _ value: String) -> Row {
            Row(kind: .field, label: label, value: value, pairs: [], quoting: nil, groupThread: nil, annotationHighlight: nil)
        }
        /// label｜value，value 以 markdown 渲染（訪談紀錄等富文字欄位）
        public static func markdown(_ label: String, _ value: String) -> Row {
            Row(kind: .markdown, label: label, value: value, pairs: [], quoting: nil, groupThread: nil, annotationHighlight: nil)
        }
        /// 粗體跨欄小標（如報價的 bundle 名）
        public static func heading(_ text: String) -> Row {
            Row(kind: .heading, label: nil, value: text, pairs: [], quoting: nil, groupThread: nil, annotationHighlight: nil)
        }
        /// 跨欄整段文字
        public static func full(_ value: String) -> Row {
            Row(kind: .full, label: nil, value: value, pairs: [], quoting: nil, groupThread: nil, annotationHighlight: nil)
        }
        /// 一列多組 label｜value
        public static func pairs(_ pairs: [(String, String)]) -> Row {
            Row(kind: .pairs, label: nil, value: "", pairs: pairs, quoting: nil, groupThread: nil, annotationHighlight: nil)
        }
        /// 報價群組：label＝「組合項目」(多項) 或「服務項目」(單項)；total＝最右側總價（rowspan 跨整組）。
        public static func quoting(_ group: QuotingGroup) -> Row {
            Row(kind: .quoting, label: nil, value: "", pairs: [], quoting: group, groupThread: nil, annotationHighlight: nil)
        }
        /// 組內留言：單一 thread（root + 回覆，皆用 AnnotationMessage，isReply 標示是否為回覆）
        public static func groupThread(_ thread: AnnotationThread) -> Row {
            Row(kind: .groupThread, label: nil, value: "", pairs: [], quoting: nil, groupThread: thread, annotationHighlight: nil)
        }
        /// 標註留言：單一 highlight 一則（編號/標註者/標註時間 + 引用原文 + 留言串）
        public static func annotationHighlight(_ highlight: AnnotationHighlight) -> Row {
            Row(kind: .annotationHighlight, label: nil, value: "", pairs: [], quoting: nil, groupThread: nil, annotationHighlight: highlight)
        }
    }
```

在 `cellGroups(for row:)` 的 switch 補兩個 case（`.annotationHighlight` 先只回空陣列，Task 3 補上）：

```swift
        case .groupThread:
            return groupThreadCellGroups(row.groupThread)
        case .annotationHighlight:
            return []
```

在 `quotingCellGroups(_:)` 函式後面（同一個 `ClassicFormPage2` struct 內）新增：

```swift
    /// 組內留言：單一 thread 佔一列，無需編號/引文，跨欄③④⑤（同 .full 的 colspan 邏輯）。
    private func groupThreadCellGroups(_ thread: AnnotationThread?) -> [Component] {
        guard let thread else { return [] }
        return [TableCell {
            annotationThreadBody(thread.messages)
        }.class("annotationCell").attribute(named: "colspan", value: "4")]
    }

    /// 留言列表共用渲染：無留言 → 「無留言」；有留言依序渲染，isReply 往內縮排一階。
    /// 內容一律用 Plot 的 escape 建構子（Div("plain string")），不用 html: 原樣注入——
    /// 留言內容是使用者輸入，不可信任其不含破壞版面的字元。
    private func annotationThreadBody(_ messages: [AnnotationMessage]) -> Component {
        guard !messages.isEmpty else {
            return Div("無留言").class("annotationEmpty")
        }
        return ComponentGroup {
            for msg in messages {
                Div {
                    Div("\(msg.authorName) · \(msg.postedAt)").class("annotationMsgMeta")
                    Div(msg.content).class("annotationMsgBody")
                }.class(msg.isReply ? "annotationMsg annotationReply" : "annotationMsg")
            }
        }
    }
```

在 `extension ClassicFormPage2 { ... }`（`QuotingService` struct 後面）新增資料型別：

```swift
    /// 留言（標註留言的留言串、或組內留言的 thread 訊息）。isReply=true 時往內縮排一階。
    /// postedAt 是呼叫端已格式化好的顯示字串（如 "2026/08/12 10:15"），本層不做時區/格式轉換。
    public struct AnnotationMessage {
        public let authorName: String
        public let postedAt: String
        public let content: String
        public let isReply: Bool
        public init(authorName: String, postedAt: String, content: String, isReply: Bool) {
            self.authorName = authorName
            self.postedAt = postedAt
            self.content = content
            self.isReply = isReply
        }
    }

    /// 組內留言：一個獨立 thread（root + 回覆，皆為 AnnotationMessage，isReply 標示層級）。
    public struct AnnotationThread {
        public let messages: [AnnotationMessage]
        public init(messages: [AnnotationMessage]) {
            self.messages = messages
        }
    }
```

在 `ClassicStylesheet.swift` 的 `css` 字串常數末尾（`.ckbox` 那行之後，收尾 `"""` 之前）新增：

```
    /* 標註留言 / 組內留言 附錄（第 2 頁尾部，同 classicForm2 框線與欄寬邏輯） */
    .classic .classicForm2 .annotationCell { vertical-align: top; }
    .classic .classicForm2 .annotationHead { display: flex; align-items: center; gap: 8px; margin-bottom: 3px; }
    .classic .classicForm2 .annotationBadge { display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; border: 1.2px solid #000; font-weight: 700; font-size: 0.95rem; }
    .classic .classicForm2 .annotationUnresolved { color: #555; font-size: 0.95rem; }
    .classic .classicForm2 .annotationMeta { color: #333; font-size: 0.95rem; }
    .classic .classicForm2 .annotationQuote { margin: 2px 0 6px 0; font-style: italic; }
    .classic .classicForm2 .annotationEmpty { color: #666; font-style: italic; }
    .classic .classicForm2 .annotationMsg { margin-top: 6px; }
    .classic .classicForm2 .annotationMsg.annotationReply { margin-left: 20px; padding-left: 10px; border-left: 2px solid #ccc; }
    .classic .classicForm2 .annotationMsgMeta { color: #555; font-size: 0.92rem; }
    .classic .classicForm2 .annotationMsgBody { font-size: 1.0rem; }
```

- [ ] **Step 4: 執行測試確認通過**

Run: `set -o pipefail; swift test --filter classicPage2RendersGroupThread 2>&1 | tail -60`
Expected: 兩支 PASS

- [ ] **Step 5: Commit**

```bash
git add Sources/HandoverDocumentHTML/Classic/ClassicFormPage2.swift Sources/HandoverDocumentHTML/Classic/ClassicStylesheet.swift Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift
git commit -m "$(cat <<'EOF'
[ADD] Classic PDF 第2頁新增「組內留言」附錄區塊

新增 ClassicFormPage2.Row.groupThread，渲染未綁定 highlight 的表單層
留言串（root + 回覆縮排），呼叫端只需組 Section(label: "組內留言", rows: ...)。

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: 新增「標註留言」附錄（`ClassicFormPage2.Row.annotationHighlight`）

**Files:**
- Modify: `Sources/HandoverDocumentHTML/Classic/ClassicFormPage2.swift`
- Test: `Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift`

**Interfaces:**
- Consumes：Task 2 的 `AnnotationMessage`、`annotationThreadBody(_:)`
- Produces：
  - `public struct ClassicFormPage2.AnnotationHighlight { numberLabel: String; isPositioned: Bool; authorName: String; annotatedAt: String; quotedText: String; messages: [AnnotationMessage] }`
  - `cellGroups(for row:)` 的 `.annotationHighlight` case 補上實作（Task 2 先留空陣列）

- [ ] **Step 1: 寫失敗測試**

```swift
@Test func classicPage2RendersAnnotationHighlightWithBadgeAndQuote() {
    let doc = ClassicHandoverDocument(
        page1: .init(companyName: "範例股份有限公司"),
        page2Sections: [
            .init(label: "標註留言", rows: [
                .annotationHighlight(.init(
                    numberLabel: "1",
                    isPositioned: true,
                    authorName: "陳雅婷",
                    annotatedAt: "2026/08/12 10:15",
                    quotedText: "公司設立年度已逾十年",
                    messages: [
                        .init(authorName: "陳雅婷", postedAt: "2026/08/12 10:16", content: "此段需跟客戶確認最新登記資料是否有異動。", isReply: false),
                        .init(authorName: "林志豪", postedAt: "2026/08/12 14:02", content: "已致電確認，登記地址與股權結構均無變更。", isReply: true),
                    ]
                ))
            ])
        ]
    )
    let html = doc.render()
    #expect(html.contains("標註留言"))
    #expect(html.contains("annotationBadge"))
    #expect(html.contains(">1<"))
    #expect(html.contains("陳雅婷 · 2026/08/12 10:15"))
    #expect(html.contains("公司設立年度已逾十年"))
    #expect(html.contains("annotationReply"))
}

@Test func classicPage2RendersUnpositionedAnnotationWithoutBadge() {
    let doc = ClassicHandoverDocument(
        page1: .init(companyName: "範例股份有限公司"),
        page2Sections: [
            .init(label: "標註留言", rows: [
                .annotationHighlight(.init(
                    numberLabel: "位置無法定位",
                    isPositioned: false,
                    authorName: "陳雅婷",
                    annotatedAt: "2026/08/09 09:10",
                    quotedText: "客戶目前設有三個營業據點",
                    messages: []
                ))
            ])
        ]
    )
    let html = doc.render()
    #expect(html.contains("位置無法定位"))
    #expect(html.contains("annotationUnresolved"))
    #expect(!html.contains("annotationBadge"))
    #expect(html.contains("無留言"))
}
```

- [ ] **Step 2: 執行測試確認失敗**

Run: `set -o pipefail; swift test --filter classicPage2RendersAnnotationHighlight 2>&1 | tail -60`
Run: `set -o pipefail; swift test --filter classicPage2RendersUnpositionedAnnotation 2>&1 | tail -60`
Expected: 編譯失敗（`AnnotationHighlight` 尚未定義）；第一支若已編譯過但 `.annotationHighlight` case 回空陣列，則跑得過編譯但斷言失敗（找不到 "標註留言" 內容）

- [ ] **Step 3: 實作**

在 `cellGroups(for row:)` 把 Task 2 留的 `case .annotationHighlight: return []` 換成：

```swift
        case .annotationHighlight:
            return annotationHighlightCellGroups(row.annotationHighlight)
```

在 `groupThreadCellGroups(_:)` 後面新增：

```swift
    /// 標註留言：編號徽章（未定位時純文字不加框）＋標註者/時間＋引文＋留言串，跨欄③④⑤。
    private func annotationHighlightCellGroups(_ item: AnnotationHighlight?) -> [Component] {
        guard let item else { return [] }
        return [TableCell {
            Div {
                Span(item.numberLabel).class(item.isPositioned ? "annotationBadge" : "annotationUnresolved")
                Span("\(item.authorName) · \(item.annotatedAt)").class("annotationMeta")
            }.class("annotationHead")
            Div(item.quotedText).class("annotationQuote")
            annotationThreadBody(item.messages)
        }.class("annotationCell").attribute(named: "colspan", value: "4")]
    }
```

在 `extension ClassicFormPage2 { ... }`（`AnnotationThread` 後面）新增：

```swift
    /// 標註留言：單一 highlight 的展示資料。isPositioned=false 時 numberLabel 顯示為說明文字
    /// （如「位置無法定位」）、不加方框徽章；quotedText 一律顯示原始 anchor.exact，即使未定位。
    public struct AnnotationHighlight {
        public let numberLabel: String
        public let isPositioned: Bool
        public let authorName: String
        public let annotatedAt: String
        public let quotedText: String
        public let messages: [AnnotationMessage]
        public init(numberLabel: String, isPositioned: Bool, authorName: String, annotatedAt: String, quotedText: String, messages: [AnnotationMessage]) {
            self.numberLabel = numberLabel
            self.isPositioned = isPositioned
            self.authorName = authorName
            self.annotatedAt = annotatedAt
            self.quotedText = quotedText
            self.messages = messages
        }
    }
```

- [ ] **Step 4: 執行測試確認通過**

Run: `set -o pipefail; swift test --filter classicPage2RendersAnnotationHighlight 2>&1 | tail -60`
Run: `set -o pipefail; swift test --filter classicPage2RendersUnpositionedAnnotation 2>&1 | tail -60`
Expected: 兩支 PASS

- [ ] **Step 5: 跑全套測試確認沒有破壞既有行為**

Run: `set -o pipefail; swift test 2>&1 | tail -60`
Expected: 全部 PASS

- [ ] **Step 6: Commit**

```bash
git add Sources/HandoverDocumentHTML/Classic/ClassicFormPage2.swift Tests/PDFGeneratorTests/HandoverDocumentHTMLTests.swift
git commit -m "$(cat <<'EOF'
[ADD] Classic PDF 第2頁新增「標註留言」附錄區塊

新增 ClassicFormPage2.Row.annotationHighlight，渲染每個 highlight 的
編號徽章／標註者/時間／引文／留言串；定位失敗時顯示「位置無法定位」
且不加方框徽章，但仍完整列出留言（呼應規劃討論：留言不可丟棄）。

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Demo fixture（`Sources/Main/main.swift`）＋人工目視驗證

**Files:**
- Modify: `Sources/Main/main.swift`

**Interfaces:**
- Consumes：Task 2/3 的 `.groupThread`/`.annotationHighlight`
- Produces：無（純示範／目視驗證用，不影響 library 行為）

> 這個 repo 的 `main.swift` 一直維護一份「把所有 Classic 區塊示範一次」的 fixture（見 spec 調查結果第 1 節），新增區塊照既有慣例補一份，讓人可以 `swift run Main` 跑出含新附錄的實際 PDF/HTML 目視確認排版。

- [ ] **Step 1: 找到 Classic demo 的 `page2Sections` 陣列組裝處**

Run: `grep -n "page2Sections" Sources/Main/main.swift`

- [ ] **Step 2: 在陣列最後追加兩個 Section**

在既有 `page2Sections: [...]` 陣列字面量的最後一個 element 後面追加（保留原本已有的所有 section，只是新增兩筆）：

```swift
    .init(label: "組內留言", rows: [
        .groupThread(.init(messages: [
            .init(authorName: "林志豪", postedAt: "2026/08/11 17:05", content: "這份訪談表整體資料齊全，建議下週提交複核。", isReply: false),
            .init(authorName: "陳雅婷", postedAt: "2026/08/11 17:40", content: "收到，我這邊會再補一份財務報表附件。", isReply: true),
        ])),
    ]),
    .init(label: "標註留言", rows: [
        .annotationHighlight(.init(
            numberLabel: "1", isPositioned: true, authorName: "陳雅婷", annotatedAt: "2026/08/12 10:15",
            quotedText: "公司設立年度已逾十年",
            messages: [
                .init(authorName: "陳雅婷", postedAt: "2026/08/12 10:16", content: "此段需跟客戶確認最新登記資料是否有異動。", isReply: false),
                .init(authorName: "林志豪", postedAt: "2026/08/12 14:02", content: "已致電確認，登記地址與股權結構均無變更。", isReply: true),
            ]
        )),
        .annotationHighlight(.init(
            numberLabel: "2", isPositioned: true, authorName: "王小明", annotatedAt: "2026/08/10 09:00",
            quotedText: "毛利率略有下滑", messages: []
        )),
        .annotationHighlight(.init(
            numberLabel: "位置無法定位", isPositioned: false, authorName: "陳雅婷", annotatedAt: "2026/08/09 09:10",
            quotedText: "客戶目前設有三個營業據點",
            messages: [
                .init(authorName: "陳雅婷", postedAt: "2026/08/15 08:52", content: "此標記對應的原文已被修改，目前系統無法定位，請確認是否仍需保留此則留言。", isReply: false),
                .init(authorName: "林志豪", postedAt: "2026/08/15 09:30", content: "要保留，留言內容對後續複核仍有參考價值。", isReply: true),
            ]
        )),
    ]),
```

- [ ] **Step 3: 執行 demo 確認可編譯、可產出**

Run: `set -o pipefail; swift run Main 2>&1 | tail -30`
Expected: 正常執行完畢無 crash（實際輸出檔案位置依 `main.swift` 現有邏輯，人工打開確認版面）

- [ ] **Step 4: Commit**

```bash
git add Sources/Main/main.swift
git commit -m "$(cat <<'EOF'
[ADD] Classic demo 補上「組內留言」「標註留言」附錄示範資料

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: 打 tag 釋出新版本

**Files:** 無程式碼異動

**Interfaces:**
- Produces：`v1.32.0` tag，供 `HandoverDocumentViewContext` 那份 plan 的 Task 8（`swift package update`）撿到

- [ ] **Step 1: 確認在 main 分支且乾淨**

Run: `git status --short`
Expected: 無輸出（工作區乾淨）；若本 plan 是在 worktree/feature branch 上做的，先依專案既有流程開 PR 合併回 main，合併後才執行下一步

- [ ] **Step 2: 打 tag 並 push**

```bash
git tag 1.32.0
git push origin 1.32.0
```

- [ ] **Step 3: 確認 tag 已存在於 remote**

Run: `git ls-remote --tags origin | grep 1.32.0`
Expected: 看到 `1.32.0` 對應的 commit hash
