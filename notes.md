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
