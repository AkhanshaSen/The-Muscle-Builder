allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// AGP 9 release lint can crash in Flutter plugin sources; disable vital lint tasks
// without importing deprecated AppExtension/LibraryExtension types in this script.
subprojects {
    afterEvaluate {
        tasks.matching {
            it.name == "lintVitalAnalyzeRelease" || it.name.startsWith("lintVital")
        }.configureEach { enabled = false }
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