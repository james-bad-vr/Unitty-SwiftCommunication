using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.Diagnostics;

using System.IO;
using System.Linq;

public static class SwiftPostProcess
{

    [PostProcessBuild]
    public static void OnPostProcessBuild(BuildTarget buildTarget, string buildPath)
    {
        if (buildTarget == BuildTarget.iOS)
        {
            var projPath = buildPath + "/Unity-VisionOS.xcodeproj/project.pbxproj";
            var proj = new PBXProject();
            proj.ReadFromFile(projPath);

            var targetGuid = proj.TargetGuidByName(PBXProject.GetUnityTestTargetName());


            proj.SetBuildProperty(targetGuid, "ENABLE_BITCODE", "NO");



            proj.SetBuildProperty(targetGuid, "SWIFT_OBJC_BRIDGING_HEADER", "Libraries/Plugins/visionOS/UnityVisionOSPlugin/Source/UnityPlugin-Bridging-Header.h");

            proj.SetBuildProperty(targetGuid, "SWIFT_OBJC_INTERFACE_HEADER_NAME", "UnityVisionOSPlugin-Swift.h");

            proj.SetBuildProperty(targetGuid, "CODE_SIGN_ENTITLEMENTS", "Unity-VisionOS.entitlements");



            proj.AddBuildProperty(targetGuid, "LD_RUNPATH_SEARCH_PATHS", "@executable_path/Frameworks $(PROJECT_DIR)/lib/$(CONFIGURATION) $(inherited)");
            proj.AddBuildProperty(targetGuid, "FRAMERWORK_SEARCH_PATHS",
                "$(inherited) $(PROJECT_DIR) $(PROJECT_DIR)/Frameworks");
            proj.AddBuildProperty(targetGuid, "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES", "YES");
            proj.AddBuildProperty(targetGuid, "DYLIB_INSTALL_NAME_BASE", "@rpath");
            proj.AddBuildProperty(targetGuid, "LD_DYLIB_INSTALL_NAME",
                "@executable_path/../Frameworks/$(EXECUTABLE_PATH)");
            proj.AddBuildProperty(targetGuid, "DEFINES_MODULE", "YES");
            proj.AddBuildProperty(targetGuid, "SWIFT_VERSION", "4.0");
            proj.AddBuildProperty(targetGuid, "COREML_CODEGEN_LANGUAGE", "Swift");

            // Add camera usage descriptions to Info.plist
            string plistPath = buildPath + "/Info.plist";
            PlistDocument plist = new PlistDocument();
            plist.ReadFromFile(plistPath);

            // Add camera usage description
            plist.root.SetString("NSCameraUsageDescription", "This app requires camera access to detect and stream video from UVC devices.");

            plist.WriteToFile(plistPath);



            proj.WriteToFile(projPath);
        }
    }

}
