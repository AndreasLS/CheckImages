# CheckImages

Command Line Tool that enables xcode build phase to check the images in your Assets folder and the images used in storyboards, xib and code.

## Usage

#### Important:

Your project MUST have an enum that references ALL your image names. The tool will scan your enum to check the images in your project. Otherwise, it's almost impossible to determinate what images that you use.

Here is a example that you could use to create your own enum:

```swift
enum Images: String {
  case smile = "icon_smile"
  case sad   = "icon_sad"
}
```
It can be executed at a Terminal or integrated with the Build Phase of your project.

### At Terminal:

The tool uses 3 parameters to work: an image name enum, the assets directory and the code directory (the one with your xib and storyboards specifically).

Example:

```sh
./CheckImages "./Project/MyEnum.swift" "./Project/Assets.xcassets" "./Project/"
```

### At Build Phase:

- Copy the tool at your project's root.

- In your project settings, navigate to Build Phase Tab and add a new Run Script Phase.

- In the script editor, type the below code, setting it with your project values:

```sh
${SOURCE_ROOT}/CheckImages "${SOURCE_ROOT}/MyProject/MyEnum.swift" "${SOURCE_ROOT}/Project/Assets.xcassets" "${SOURCE_ROOT}/Project/"
```

- Build your project.

## Result

- Images found at your project (enum and xib) but not in your Assets (you should add those images to your Assets)

*AND*

- Images found at your Assets but not in your code (enum and xib) (you should remove those images from your Assets)

*OR*

- Success. Everything is fine :)
