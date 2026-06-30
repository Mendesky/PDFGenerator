//
//  ClassicStylesheet.swift
//  PDFGenerator
//
//  舊版框線表單樣式（scope 在 .classic）。兩頁都用「單一扁平表格」：所有框線出自同一個
//  border-collapse，粗細一致（1px）；不用巢狀表格（巢狀會在交界處疊成雙線/變粗）。
//  注意：CSS 經 <style> text 會被 HTML escape，不能用 `>` 子選擇器（會變 &gt;），一律用 class。
//

enum ClassicStylesheet {
    static let css = """
    .classic { color: #000; }
    .classic p { margin: 0; }

    /* ===== 標題列 ===== */
    /* 第 1 頁：單純置中 */
    .classic .titleRow { text-align: center; margin-bottom: 4px; }
    /* 第 2 頁：左空白 | 置中標題 | 右上角(連結按鈕+QR) */
    .classic .titleRow2 { display: flex; align-items: flex-start; margin-bottom: 4px; }
    .classic .titleSpacer { flex: 1 1 0; }
    /* 標題用一般字重：粗體楷體（特粗楷體）缺「錄/訊」等字形會變空白，故不加粗 */
    .classic .formTitle { font-size: 1.7rem; font-weight: normal; margin: 0; letter-spacing: 6px; }
    .classic .titleRow2 .formTitle { flex: 0 0 auto; align-self: center; }
    .classic .classicTopRight { flex: 1 1 0; display: flex; flex-direction: column; align-items: flex-end; gap: 4px; }
    .classic .shareUrlContainer { display: flex; gap: 6px; }
    .classic .shareUrlContainer .url { display: flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 4px; background: #3A9CCD; white-space: nowrap; }
    .classic .shareUrlContainer .url a { color: #F1F3F5; font-size: 0.8rem; text-decoration: none; white-space: nowrap; }
    .classic .shareUrlContainer .urlIcon { display: flex; align-items: center; }
    .classic .shareUrlContainer .urlIcon svg { display: block; }
    .classic .qrImage svg { display: block; width: 58px; height: 58px; }

    /* ===== 主表（單一扁平表格，框線統一 1px） ===== */
    .classic table.classicForm, .classic table.classicForm2 { width: 100%; border-collapse: collapse; }
    .classic table.classicForm { table-layout: fixed; }
    .classic table.classicForm2 { table-layout: auto; margin-top: 4px; }
    .classic .sectionLabel, .classic .fieldLabel, .classic .fieldValue, .classic .blockCell { border: 1px solid #000; }

    /* 區塊直書標籤（逐字斷行堆疊，不用 writing-mode，避免末字被裁） */
    /* 非粗體：粗體楷體（特粗楷體）缺「訊/錄」等字形會變空白，故區塊標籤不加粗 */
    .classic .sectionLabel { width: 26px; text-align: center; vertical-align: middle; background: #f2f2f2; font-weight: normal; padding: 2px; }
    .classic .vlabel { line-height: 1.3; text-align: center; }
    .classic .vlabelChar { text-align: center; }

    /* 欄位格 */
    .classic .fieldLabel { background: #f7f7f7; width: 96px; text-align: center; line-height: 1.3; word-break: keep-all; padding: 3px 8px; font-size: 1.08rem; vertical-align: middle; }
    .classic .fieldValue { word-break: break-all; padding: 3px 8px; font-size: 1.08rem; vertical-align: top; }
    .classic .blockCell { padding: 0; vertical-align: top; }
    /* 第 2 頁：label 欄固定窄寬、長標籤換行（避免整欄被「代辦年度CTP申報」撐寬） */
    .classic .classicForm2 .fieldLabel { width: 110px; white-space: normal; word-break: normal; }
    .classic .classicForm2 .rowHeading { background: #fafafa; font-weight: 700; }
    /* 一列多組 label｜value（扣繳人數／分支機構家數；各式發票張數） */
    .classic .pairLabel { color: #555; margin-right: 6px; }
    .classic .pairValue { font-weight: 600; margin-right: 22px; }

    /* 訪談內容 / 服務 / 備註 區塊（在 blockCell 內） */
    .classic .interviewBlock,
    .classic .serviceBlock,
    .classic .remarkBlock { padding: 4px 8px; font-size: 1.08rem; }
    .classic .interviewBlock p,
    .classic .remarkBlock p { padding: 1px 0; }
    .classic .serviceBlock { line-height: 1.85; }
    .classic .invoiceLine { padding-top: 3px; }

    /* 聯絡人（可多位，姓名一行、各聯絡方式各自縮排一行） */
    .classic .contactBlock { display: flex; flex-direction: column; gap: 6px; }
    .classic .contactLine { font-size: 1.08rem; }
    .classic .contactNameLine { padding-bottom: 1px; }
    .classic .contactName { font-weight: 700; }
    .classic .contactRel { color: #333; }
    .classic .contactMethod { padding-left: 1.6em; color: #222; }

    /* 勾選 ■/□ */
    .classic .ckbox { margin-right: 12px; white-space: nowrap; font-size: 1.08rem; }
    """
}
