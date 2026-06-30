//
//  Stylesheet.swift
//  PDFGenerator
//
//  客戶訪談紀錄表的集中式樣式 — 由 Frontend 各 print-page 元件 SCSS 移植，
//  全部 scope 在根節點 .handover 下，避免污染其他文件樣式。
//  設計系統：文字 #686868、淺灰 #939393、邊框 #E7E7E7、chip 白底、連結藍 #3A9CCD、圓角 4px。
//

enum Stylesheet {
    static let css = """
    .handover { color: #686868; }
    .handover p { margin: 0; }

    /* ===== header ===== */
    .handover .printHeader { width: 100%; display: flex; flex-direction: column; gap: 12px; }
    .handover .printHeader .logo { display: flex; justify-content: flex-end; align-items: center; width: 100%; }
    .handover .shareUrlContainer { display: flex; padding: 4px; align-items: center; gap: 6px; }
    .handover .shareUrlContainer .url { display: flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 4px; background: #3A9CCD; white-space: nowrap; }
    .handover .shareUrlContainer .url a { color: #F1F3F5; font-size: 9pt; text-decoration: none; white-space: nowrap; }
    .handover .shareUrlContainer .urlIcon { display: flex; align-items: center; }
    .handover .printHeader .title { display: flex; padding: 8pt 12pt; align-items: center; }
    .handover .printHeader .title p { font-size: 16pt; font-weight: 500; }
    .handover .companyContainer { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; padding: 0 8px; }
    .handover .companyContainer .label { display: flex; padding: 6pt 8pt; align-items: center; border-radius: 4px; border: 1px solid #E7E7E7; background: #FFF; }
    .handover .companyContainer .name { display: flex; flex-direction: column; align-items: flex-start; gap: 2px; flex: 1 0 0; }
    .handover .companyContainer .name .bold { font-size: 16pt; font-weight: 500; }
    .handover .companyContainer .name .padding4TopBottom p { font-size: 11pt; }
    .handover .gap8 { display: flex; align-items: center; gap: 8pt; }
    .handover .dealDate { display: flex; flex-direction: column; align-items: flex-start; gap: 2px; }
    .handover .dealDate p { color: #939393; font-size: 10pt; }
    .handover .qrcodeInfo { display: flex; flex-direction: column; align-items: center; gap: 2pt; }
    .handover .qrcodeInfo .qrImage svg { display: block; width: 56px; height: 56px; }
    .handover .qrcodeInfo .token { font-size: 7pt; font-weight: 500; }

    /* ===== focus bar ===== */
    .handover .focusBar { width: 100%; display: flex; justify-content: center; align-items: flex-start; flex-wrap: wrap; gap: 6px 12px; padding: 4px; }
    .handover .focusBar .item { display: flex; padding: 6px 8px; flex-direction: column; align-items: center; gap: 4px; }
    .handover .focusBar .item .type { display: flex; padding: 4px 8px; align-items: center; gap: 2px; border-radius: 4px; border: 1px solid #E7E7E7; background: #FFF; white-space: nowrap; }
    .handover .focusBar .text { color: #686868; font-size: 10pt; white-space: nowrap; }
    .handover .focusBar .text.bold { font-weight: 600; }
    .handover .focusBar .value { font-size: 14pt; font-weight: 600; }

    /* ===== two-column（table-layout: fixed 確保左右各半） ===== */
    .handover table.contentContainer { width: 100%; border-collapse: collapse; table-layout: fixed; }
    .handover .contentContainer .info { width: 50%; vertical-align: top; }
    .handover .contentContainer .left { border-right: 1px solid #D3D3D3; padding-right: 10px; }
    .handover .contentContainer .right { padding-left: 12px; }
    .handover .divider { width: 100%; border-top: 1px solid #D3D3D3; margin: 4px 0; }

    /* ===== quoting bundle ===== */
    .handover .quotingBundle { display: flex; flex-direction: column; gap: 8px; padding: 4px 8px; width: 100%; }
    .handover .bundle { width: 100%; display: flex; flex-direction: column; gap: 8px; }
    .handover .bundle .bundleName p { font-size: 12pt; font-weight: 600; }
    .handover table.unit { width: 100%; border-collapse: collapse; break-inside: avoid-page; }
    .handover .unit .services { vertical-align: top; }
    .handover .unit .service { margin-bottom: 6px; }
    .handover .unit .serviceName { padding: 0; }
    .handover .unit .serviceName p { font-size: 12pt; font-weight: 600; }
    .handover .unit .configUnit { display: flex; align-items: baseline; gap: 4px; flex-wrap: wrap; }
    .handover .unit .configKey { padding: 0; }
    .handover .unit .configUnit p { font-size: 11pt; font-weight: 400; color: #686868; }
    .handover .unit .price { vertical-align: top; text-align: right; white-space: nowrap; width: 1%; padding-left: 16px; padding-right: 4px; }
    .handover .unit .price .dollar { font-size: 14pt; font-weight: 500; }
    .handover .unit .price .period { color: #939393; font-size: 9pt; }
    .handover .dottedLine { width: 100%; border-top: 1px dashed #D3D3D3; margin: 2px 0; }

    /* ===== additional service ===== */
    .handover .additionalService { display: flex; flex-direction: column; gap: 4px; padding: 4px 8px; width: 100%; }
    .handover .additionalService .title p { font-size: 11pt; color: #939393; }
    .handover .additionalService table.unit { width: 100%; border-collapse: collapse; }
    .handover .additionalService .nameCell { vertical-align: top; }
    .handover .additionalService .name p { font-size: 11pt; }
    .handover .additionalService .price { text-align: right; white-space: nowrap; width: 1%; vertical-align: top; padding-left: 16px; padding-right: 4px; }
    .handover .additionalService .price .dollar { font-size: 12pt; font-weight: 500; }
    .handover .additionalService .price .period { color: #939393; font-size: 9pt; }

    /* ===== 共用 chip / 區塊 ===== */
    .handover .chip, .handover .preserviceOrg .labelContainer .label {
        display: flex; align-items: center; padding: 2px 8px; line-height: 1.3; white-space: nowrap;
        border: 1px solid #E7E7E7; border-radius: 4px; background: #FFF; }
    .handover .designatedInfo, .handover .maintenanceInfo, .handover .contactInfo, .handover .preserviceOrg, .handover .evidenceInfo {
        display: flex; flex-direction: column; gap: 6px; padding: 4px 8px; width: 100%; }

    /* ===== 指派資訊 ===== */
    .handover .designatedInfo .service { display: flex; justify-content: flex-start; align-items: baseline; gap: 10px; padding: 2px 0; }
    .handover .designatedInfo .labelGroup { display: inline-block; white-space: nowrap; }
    .handover .designatedInfo .title { display: inline; color: #939393; font-size: 10pt; margin-right: 4px; }
    .handover .designatedInfo .bold { display: inline; font-weight: 600; font-size: 11pt; }
    .handover .designatedInfo .value { white-space: nowrap; font-size: 11pt; }

    /* ===== 熟悉人員 / 來源 / 訪談人 ===== */
    .handover .maintenanceInfo .unit { display: flex; flex-direction: column; gap: 4px; }
    .handover .maintenanceInfo .title p { color: #939393; font-size: 10pt; }
    .handover .maintenanceInfo .source .bold { font-weight: 600; font-size: 11pt; }
    .handover .maintenanceInfo .staffContainer { display: flex; flex-direction: column; align-items: flex-start; gap: 4px; }
    .handover .maintenanceInfo .staff { white-space: nowrap; }
    .handover .maintenanceInfo .staff .info { display: inline; }
    .handover .maintenanceInfo .staff .label { display: inline-block; vertical-align: middle; margin-right: 4px; padding: 2px 8px; line-height: 1.3; border: 1px solid #E7E7E7; border-radius: 4px; background: #FFF; }
    .handover .maintenanceInfo .staff .label p { display: inline; font-size: 11pt; color: #686868; }
    .handover .maintenanceInfo .staff .name { display: inline-block; vertical-align: middle; }
    .handover .maintenanceInfo .staff .name .bold { font-weight: 600; font-size: 11pt; }

    /* ===== 聯絡人 + 公司聯絡 ===== */
    .handover .contactInfo { gap: 10px; }
    .handover .contactInfo .title p { color: #939393; font-size: 10pt; }
    .handover .contactInfo .contactUnit { display: flex; flex-direction: column; gap: 4px; padding: 2px 0; }
    .handover .contactInfo .contactUnit .name { display: flex; align-items: baseline; gap: 6px; }
    .handover .contactInfo .contactUnit .name p { font-weight: 600; font-size: 12pt; }
    .handover .contactInfo .contactUnit .name .gender { font-weight: 400; font-size: 10pt; color: #939393; }
    .handover .contactInfo .relationship p { color: #939393; font-size: 9pt; }
    .handover .contactInfo .communications { display: flex; flex-direction: column; gap: 2px; }
    .handover .contactInfo .methodRow { display: flex; justify-content: flex-start; align-items: baseline; gap: 8px; }
    .handover .contactInfo .methodRow .type { color: #939393; font-size: 10pt; white-space: nowrap; }
    .handover .contactInfo .methodRow .right { text-align: left; font-size: 12pt; font-weight: 600; }
    .handover .contactInfo .unit { display: flex; flex-direction: column; gap: 2px; }
    .handover .contactInfo .unit .title p { color: #939393; font-size: 10pt; font-weight: 400; }
    .handover .contactInfo .unit p { font-size: 12pt; font-weight: 600; }
    .handover .contactInfo .phone { display: flex; gap: 8px; }
    .handover .contactInfo .phone .unit { flex: 1 1 0; }

    /* ===== 統購（發票憑證）— gap8 為上下堆疊（label 在上、值在下），各列緊湊 ===== */
    .handover .evidenceInfo { line-height: 1.3; }
    .handover .evidenceInfo .gap8 { display: flex; flex-direction: column; align-items: flex-start; gap: 1px; }
    .handover .evidenceInfo .gap8 .text { font-weight: 600; }
    .handover .evidenceInfo .gap4 { display: flex; flex-direction: column; gap: 2px; }
    .handover .evidenceInfo .evidence { display: block; line-height: 1.4; }
    .handover .evidenceInfo .evidence p { display: inline; }
    .handover .evidenceInfo .evidence .grey60, .handover .evidenceInfo .evidence .text { margin-right: 4px; }
    .handover .evidenceInfo .grey60 { color: #939393; font-size: 10pt; }
    .handover .evidenceInfo .evidence .grey60 { font-size: 12pt; font-weight: 600; }
    .handover .evidenceInfo .text { font-size: 12pt; font-weight: 600; }
    .handover .evidenceInfo .bold { font-weight: 600; }

    /* ===== 前手事務所 ===== */
    .handover .preserviceOrg .unit { display: flex; flex-direction: column; gap: 4px; }
    .handover .preserviceOrg .title { color: #939393; font-size: 10pt; }
    .handover .preserviceOrg .content { font-size: 11pt; }
    .handover .preserviceOrg .labelContainer { display: flex; flex-wrap: wrap; align-items: flex-start; gap: 4px; }
    .handover .preserviceOrg .labelContainer .label .text { font-size: 11pt; color: #686868; }

    /* ===== 營運資訊 ===== */
    .handover .operationInfo { display: flex; flex-direction: column; gap: 12px; padding: 4px 8px; width: 100%; }
    .handover .operationInfo .horizontal { display: flex; gap: 8px; }
    .handover .operationInfo .horizontal .unit { flex: 1 1 0; }
    .handover .operationInfo .vertical { display: flex; flex-direction: column; gap: 4px; }
    .handover .operationInfo .unit { display: flex; flex-direction: column; gap: 2px; }
    .handover .operationInfo .title p { color: #939393; font-size: 10pt; }
    .handover .operationInfo .content p { font-size: 11pt; font-weight: 500; }

    /* ===== 訪談紀錄 ===== */
    .handover .interviewInfo { display: flex; flex-direction: column; gap: 12px; padding: 4px 8px; width: 100%; }
    .handover .interviewInfo .unit { display: flex; flex-direction: column; gap: 2px; }
    .handover .interviewInfo .title p { color: #939393; font-size: 10pt; }
    .handover .interviewInfo .description { font-size: 11pt; }
    .handover .interviewInfo .description p { margin: 0; }
    .handover .interviewInfo .description ul, .handover .interviewInfo .description ol { margin: 0; padding-left: 1.4em; }

    /* ===== 關係企業 ===== */
    .handover .relatedBusiness { display: flex; flex-direction: column; gap: 6px; padding: 4px 8px; width: 100%; }
    .handover .relatedBusiness .title p { color: #939393; font-size: 10pt; }
    .handover .relatedBusiness .relatedContainer { display: flex; flex-direction: column; gap: 8px; }
    .handover .relatedBusiness .unit { display: flex; flex-direction: column; gap: 4px; }
    .handover .relatedBusiness .relatedType { display: flex; }
    .handover .relatedBusiness .relatedType .label { display: flex; align-items: center; line-height: 1.3; padding: 2px 8px; border: 1px solid #E7E7E7; border-radius: 4px; background: #FFF; }
    .handover .relatedBusiness .relatedType .label p { font-size: 11pt; }
    .handover .relatedBusiness .companysInfo { display: flex; flex-direction: column; gap: 6px; }
    .handover .relatedBusiness .companyUnit { display: flex; flex-direction: column; gap: 4px; }
    .handover .relatedBusiness .basicInfo { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; line-height: 1.2; }
    .handover .relatedBusiness .basicInfo p { font-size: 11pt; line-height: 1.2; }
    .handover .relatedBusiness .basicInfo .name { font-weight: 600; font-size: 12pt; }
    .handover .relatedBusiness .employeeLabel { display: inline-block; align-self: flex-start; white-space: nowrap; line-height: 1.3; padding: 3px 8px; border-radius: 4px; background: #5B9A68; }
    .handover .relatedBusiness .employeeLabel .employeeIcon { display: inline-block; vertical-align: middle; margin-right: 4px; }
    .handover .relatedBusiness .employeeLabel .employeeIcon svg { display: block; width: 12px; height: 12px; }
    .handover .relatedBusiness .employeeLabel p { display: inline; vertical-align: middle; color: #FFF; font-size: 11pt; }
    .handover .relatedBusiness .nonClient { display: flex; align-self: flex-start; align-items: center; line-height: 1.3; padding: 2px 8px; border-radius: 4px; background: #939393; }
    .handover .relatedBusiness .nonClient p { color: #FFF; font-size: 11pt; }
    .handover .relatedBusiness .description p { font-size: 10pt; color: #686868; margin: 0; }
    .handover .relatedBusiness .description ul, .handover .relatedBusiness .description ol { margin: 0; padding-left: 1.4em; }
    """
}
