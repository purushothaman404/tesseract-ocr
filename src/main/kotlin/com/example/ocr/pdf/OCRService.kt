package com.example.ocr.pdf

import com.example.ocr.pdf.enum.DocumentType
import net.sourceforge.tess4j.Tesseract
import net.sourceforge.tess4j.TesseractException
import org.springframework.stereotype.Service
import java.io.File

@Service
class OCRService {

    fun getContent(documentType: DocumentType): String {
        val tesseract = Tesseract()

        try {
            val filePath = getFilePath(documentType)
            val image = File(filePath)

            tesseract.setDatapath(System.getenv(TESSDATA_PREFIX))
            tesseract.setLanguage("eng")
            tesseract.setVariable("tessedit_create_horc", "1")
            tesseract.setPageSegMode(1)
            tesseract.setOcrEngineMode(1)

            println("Document type ===> ${documentType.name}")
            return tesseract.doOCR(image)
        } catch (e: TesseractException) {
            throw Exception(e)
        }
    }

    fun getFilePath(documentType: DocumentType): String {
        return when (documentType) {
            DocumentType.PDF -> PDF_FILE
            DocumentType.PNG -> PNG_FILE
        }
    }

    companion object {
        const val TESSDATA_PREFIX = "TESSDATA_PREFIX"

        const val PDF_FILE = "tesseract.pdf"
        const val PNG_FILE = "tesseract.png"
    }
}