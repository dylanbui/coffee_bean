allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Workaround for AGP 8.0+ namespace requirement in older libraries (like isar_flutter_libs)
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android")
            if (android is com.android.build.gradle.BaseExtension) {
                // 1. Tự động gán namespace nếu bị thiếu
                if (android.namespace == null) {
                    android.namespace = "com.coffee_bean." + project.name.replace("-", "_")
                }

                // 2. FIX: Xử lý lỗi "Incorrect package found in source AndroidManifest.xml"
                // Tạo một file Manifest sạch (không có thuộc tính package) để pass AGP 8.0+ check
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val content = manifestFile.readText()
                    if (content.contains("package=")) {
                        val patchedManifestDir = project.layout.buildDirectory.dir("patched_manifest").get().asFile
                        patchedManifestDir.mkdirs()
                        val patchedManifestFile = java.io.File(patchedManifestDir, "AndroidManifest.xml")
                        
                        // Xóa thuộc tính package bằng Regex
                        val newContent = content.replace(Regex("""package\s*=\s*"[^"]*""""), "")
                        patchedManifestFile.writeText(newContent)
                        
                        // Trỏ thư viện sử dụng file Manifest đã patch
                        android.sourceSets.getByName("main").manifest.srcFile(patchedManifestFile)
                    }
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {
    // ...
    // Add the dependency for the Google services Gradle plugin
    id("com.google.gms.google-services") version "4.4.4" apply false

}
