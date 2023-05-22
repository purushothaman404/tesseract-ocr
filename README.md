# tesseract-ocr
Kotlin Spring Boot application with Tesseract OCR operation

### Build application

```./gradlew build```

### Build docker file

```docker build -t ocr-app .```

### Run application

```docker run --rm -it -p 8080:8080 ocr-app```

### To get Image text from OCR

```GET: http://localhost:8080/ocr/image```

### To get PDF text from OCR

```GET: http://localhost:8080/ocr/pdf```
