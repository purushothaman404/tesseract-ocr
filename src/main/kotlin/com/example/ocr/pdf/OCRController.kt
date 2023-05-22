package com.example.ocr.pdf

import com.example.ocr.pdf.enum.DocumentType
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/ocr")
class OCRController(
    val ocrService: OCRService
) {

    @GetMapping("/pdf")
    fun getPdfContent(): String {
        return ocrService.getContent(DocumentType.PDF)
    }

    @GetMapping("/image")
    fun getPngImageContent(): String {
        return ocrService.getContent(DocumentType.PNG)
    }
}

