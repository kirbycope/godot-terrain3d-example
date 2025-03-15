# Notes

## Setup
https://terrain3d.readthedocs.io/en/stable/index.html
1. Create a new Forward+ project in Godot 4.4
1. Select "AssetLib"
1. Search for "Terrain"
1. Select "Terrain3D" and then "Download"
1. Check only the "addons" folder and then select "Install"
1. Select "Project" > "Project Settings..."
1. Select "Plugins"
1. Select the box to enable "Terrain3D"
1. Create a new 3d Scene
1. Rename the scene "Main" and save as `scenes/main.tscn`
1. Select "Add Child Node..." > "Terrain3D"
1. In the Inspector for the Terrain3D, select the folder icon next to "Data Directory"
	1. Data directory should now be set as "res://data"

## Textures
https://www.youtube.com/watch?v=m69C59tUbbw&t=220s
1. In the root of the project, create a new folder named `assets`
1. Download the 1K-JPG.zip for:
	- https://ambientcg.com/view?id=Ground037
	- https://ambientcg.com/view?id=Rocks006
	- https://ambientcg.com/view?id=Rocks007
	- https://ambientcg.com/view?id=Rock028
1. Unarchive the zip files in the assets directory
1. Select "3D"
1. Select the Terrain3D node from the scene tree
1. Select "Terrain3d Tools" > "Pack Textures"
1. For "Albedo", select the "_Color" jpg
1. For "Height", select the "_Displacement" jpg
1. For "Normal", select the "_NormalGL" jpg
	- If a texture only has DirectX, use it an select "Convert DirectX to OpenGL"
1. For "Roughness", select the "_Roughness" jpg
1. Ensure all images are square, ex. "w: 1024 h: 1024"
1. Select "Pack texture as..."
1. Enter `{texture_name}_packed_albedo_height` and then select "Save"
1. Enter `{texture_name}_packed_normal_roughness` and then select "Save"
1. Select "+ Add Texture"
1. Enter the `{texture_name}`
1. Load the "Albedo Texture"
1. Load the "Normal Texture"

## Models
- [SketchUp Residency Title Stonehenge](https://sketchfab.com/3d-models/sketchup-residency-title-stonehenge-b045d1987a2e44388a9c1431fe6db55e) - SKETCHUP RESIDENCY

----

## Compatibility (Experimental)
</br>https://github.com/TokisanGames/Terrain3D/issues/502
</br>https://terrain3d.readthedocs.io/en/stable/docs/nightly_builds.html

### Build the Web Export Profile
This scection is no longer needed as "Unthreaded Web builds and terrain.gdextension updates have now been included in the main branch CI."
<strike>
1. Open Command Prompt
1. Install SCons build tool, by running `pip install SCons`
	- Verify, by running `python -m SCons --version`
1. Navigate to [Godot Web Builds](https://github.com/godotengine/godot/blob/master/.github/workflows/web_builds.yml) and note the "EM_VERSION"
1. To clone Emscripten, run `git clone https://github.com/emscripten-core/emsdk.git`
1. Switch to the new directory, by runnning `cd emsdk`
1. Install the correct SDK version, by running `emsdk install 3.1.64`
1. To activate the SDK version, run `emsdk activate 3.1.64`
1. Setup the environment, by running `emsdk_env.bat`
1. To clone Terrain3D, run `git clone https://github.com/TokisanGames/Terrain3D.git`
1. Navigate to your project directory, by running `cd Terrain3D`
1. Terrain3D uses a git submodule
	1. To activate, run `git submodule init`
	1. To clone, run `git submodule update`
1. To build, run `python -m SCons platform=web target=template_debug threads=no`
1. Confirm build output, by running `dir project\addons\terrain_3d\bin\*.wasm`
1. Open [terrain.gdextension](addons\terrain_3d\terrain.gdextension) in your project
	- Add the following contents:
		> web.debug = "res://addons/terrain_3d/bin/libterrain.web.debug.wasm32.wasm"
		web.release = "res://addons/terrain_3d/bin/libterrain.web.release.wasm32.wasm"
1. Copy the "libterrain.web.release.wasm32.wasm" (generated above) to your project's "addons/terrain_3d/bin" directory
</strike>

### Get the Terrain3D Nightly Build
1. Navigate to the Terrain3D [Build All](https://github.com/TokisanGames/Terrain3D/actions/workflows/build.yml?query=branch%3Amain) GitHub Action
1. Select the latest successful job and download the artifact
1. Replace your project's [addons/terrain_3d](/addons/terrain_3d/) with the contents of the zip file
1. Copy the "libterrain.web.release.wasm32.wasm" (generated above) to your project's "addons/terrain_3d/bin" directory
1. Open _this_ project in Godot
1. Set the Render mode (at the top-right) to Compatibility and restart Godot

### Reimporting Textures
1. Select "Import" (tab next to "Scene")
1. In the FileSystem, select your [packed] texture
1. Set "Compress" > "Mode" to "VRAM Uncompressed
1. Select "Reimport(*)"
1. Repeat for each texture

### Setting the Shader
1. In the Scene tree, select the "Terrain3D"
1. In the Inspector, expand "Material"
1. Check "Shader Override Enabled"
1. Create a New Shader and add the following [working shader](https://github.com/user-attachments/files/17241271/working_shader.txt)

### Exporting
1. Navigate to `%APPDATA%/Godot/export_templates/4.4.stable` and locate "web_dlink_nothreads_debug.zip"
1. Select "Editor" > "Manage Templates"
