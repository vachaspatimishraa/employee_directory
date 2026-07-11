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
    val project = this
    project.plugins.whenPluginAdded {
        if (this.javaClass.name.startsWith("com.android.build.gradle")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Int::class.javaObjectType)
                    setCompileSdk.invoke(android, 35)
                } catch (e: Exception) {
                    try {
                        val setCompileSdkVersion = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaObjectType)
                        setCompileSdkVersion.invoke(android, 35)
                    } catch (e2: Exception) {
                        // Ignore
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
