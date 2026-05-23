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
    val configureNamespace = { p: Project ->
        val android = p.extensions.findByName("android")
        if (android != null) {
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                if (getNamespace.invoke(android) == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    val groupName = p.group.toString()
                    val fallbackNamespace = if (groupName.isNotEmpty()) groupName else "com.example.${p.name}"
                    setNamespace.invoke(android, fallbackNamespace)
                    println("Injected namespace for project ${p.name}: $fallbackNamespace")
                }
            } catch (e: Exception) {
                // Method not found or reflection failed
            }
        }
    }
    if (project.state.executed) {
        configureNamespace(project)
    } else {
        project.afterEvaluate {
            configureNamespace(project)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
