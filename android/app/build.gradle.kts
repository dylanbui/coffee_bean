plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // Add the Google services Gradle plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.dylanbui.coffeebean"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.tmlabs.coffee"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // --- BẮT ĐẦU CẤU HÌNH FLAVOR TẠI ĐÂY ---
    flavorDimensions.add("app-flavor")

    productFlavors {
        create("dev") {
            dimension = "app-flavor"
            applicationIdSuffix = ".dev" // ID sẽ là com.tmlabs.coffee.dev
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "TMLabs Dev")
        }
        create("uat") {
            dimension = "app-flavor"
            applicationIdSuffix = ".uat" // ID sẽ là com.tmlabs.coffee.uat
            versionNameSuffix = "-uat"
            resValue("string", "app_name", "TMLabs Test")
        }
        create("production") {
            dimension = "app-flavor"
            // Không có suffix để giữ ID sạch com.tmlabs.coffee cho Store
            resValue("string", "app_name", "Coffee Bean")
        }
    }
    // --- KẾT THÚC CẤU HÌNH FLAVOR ---


    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.12.0"))

    // TODO: Add the dependencies for Firebase products you want to use
    // When using the BoM, don't specify versions in Firebase dependencies
    implementation("com.google.firebase:firebase-analytics")

    // Add the dependencies for any other desired Firebase products
    // https://firebase.google.com/docs/android/setup#available-libraries
}

flutter {
    source = "../.."
}
