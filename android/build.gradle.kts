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
}

subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureProject: () -> Unit = {
        val android = extensions.findByName("android")
        if (android != null) {
            // 1. Force Compile SDK 36 for all modules
            try {
                val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Int::class.javaObjectType)
                setCompileSdk.invoke(android, 36)
            } catch (e: Exception) {
                try {
                    val setCompileSdkVersion = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaObjectType)
                    setCompileSdkVersion.invoke(android, 36)
                } catch (e2: Exception) {
                    // Ignore fallbacks
                }
            }

            // 2. Inject Namespace for libraries that don't specify it (like isar_flutter_libs)
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(android) as? String
                if (namespace.isNullOrEmpty()) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    val safeName = name.replace(Regex("[^a-zA-Z0-9_]"), "_")
                    setNamespace.invoke(android, "com.example.$safeName")
                }
            } catch (e: Exception) {
                // Ignore if it fails
            }
        }
    }

    if (state.executed) {
        configureProject()
    } else {
        afterEvaluate {
            configureProject()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
