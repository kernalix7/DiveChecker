allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Fix namespace for legacy Flutter plugins that don't specify one
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null && project.name == "flutter_libserialport") {
                try {
                    val namespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                    val getNamespaceMethod = android.javaClass.getMethod("getNamespace")
                    val currentNamespace = getNamespaceMethod.invoke(android) as? String
                    if (currentNamespace.isNullOrEmpty()) {
                        namespaceMethod.invoke(android, "dev.flutter.flutter_libserialport")
                    }
                } catch (e: Exception) {
                    // Ignore if namespace is already set or method doesn't exist
                }
            }
        }
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
