plugins {
    // Firebase services plugin (jo aapke text mein 4.5.0 likha hai)
    id("com.google.gms.google-services") version "4.5.0" apply false

    // Crashlytics plugin (Ye line extra add karni hai errors ke liye)
    id("com.google.firebase.crashlytics") version "2.9.9" apply false
}

// Yahan se aapka purana 'allprojects { ... }' wala code continue hoga...
allprojects {
    // ...
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
