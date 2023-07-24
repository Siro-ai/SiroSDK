Pod::Spec.new do |s|
	s.name         = "SiroSDK"
	s.version      = "1.0.0"
	s.summary      = "Pod for integrating Siro.ai into an iOS project"
	s.homepage     = "https://siro.ai"
	s.license = { :type => 'Copyright', :text => <<-LICENSE
									Copyright 2023 Siro.ai
								LICENSE
							}
	s.author = { "Siro.ai" => "hello@siro.ai" }
	s.source = { :git => "https://github.com/Siro-ai/SiroSDK.git", :tag => "1.0.0" }
	
	s.vendored_frameworks = "SiroKit.xcframework"
  s.dependency 'FirebaseAuth', '~> 10.12.0'
  s.dependency 'FirebaseDynamicLinks', '~> 10.12.0'
  s.dependency 'FirebaseFirestore', '~> 10.12.0'
  s.dependency 'FirebaseFirestoreSwift', '~> 10.12.0'
  s.dependency 'FirebaseStorage', '~> 10.12.0'

	s.platform = :ios
	s.ios.deployment_target  = '15.0'
end