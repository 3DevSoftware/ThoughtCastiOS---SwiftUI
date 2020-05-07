# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

target 'ThoughtCast' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ThoughtCast
pod 'SwipeCellKit'
pod 'Firebase/Core'
pod 'Firebase/Firestore'
pod 'Bugsnag'
pod 'ImageSlideshow', '~> 1.6'
pod 'DKPhotoGallery'
pod 'Bluejay', '~> 0.8'
pod "PlainPing"
pod 'CustomNavigationBar'

  target 'ThoughtCastTests' do

    inherit! :search_paths
    # Pods for testing
  end

  target 'ThoughtCastUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
	config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end


end
