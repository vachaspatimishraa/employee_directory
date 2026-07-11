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
    val injectNamespace = {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                // 1. Inject Namespace
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(android) as? String
                if (namespace.isNullOrEmpty()) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    val safeName = project.name.replace(Regex("[^a-zA-Z0-9_]"), "_")
                    setNamespace.invoke(android, "com.example.$safeName")
                }

                // 2. Override Manifest if package attribute is present (e.g. for isar_flutter_libs)
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    var manifestContent = manifestFile.readText()
                    if (manifestContent.contains("package=")) {
                        // Generate modified manifest in root project's build directory (inside workspace)
                        val buildDirManifest = rootProject.layout.buildDirectory.file("generated/manifests/${project.name}/AndroidManifest.xml").get().asFile
                        buildDirManifest.parentFile.mkdirs()
                        
                        // Strip the package="..." attribute
                        manifestContent = manifestContent.replace(Regex("""package="[^"]*""""), "")
                        buildDirManifest.writeText(manifestContent)
                        
                        // Redirect Android manifest source set to the generated one
                        val sourceSets = android.javaClass.getMethod("getSourceSets").invoke(android)
                        val mainSourceSet = sourceSets.javaClass.getMethod("getByName", String::class.java).invoke(sourceSets, "main")
                        val manifestSource = mainSourceSet.javaClass.getMethod("getManifest").invoke(mainSourceSet)
                        manifestSource.javaClass.getMethod("srcFile", Any::class.java).invoke(manifestSource, buildDirManifest)
                    }
                }
            } catch (e: Exception) {
                // Ignore
            }
        }
    }
    if (project.state.executed) {
        injectNamespace()
    } else {
        project.afterEvaluate {
            injectNamespace()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
