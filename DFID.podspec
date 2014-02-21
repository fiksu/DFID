Pod::Spec.new do |s|
  s.name         = "DFID"
  s.version      = "7.0.0-alpha"
  s.summary      = "A Digital Fingerprinting library for iOS. (Fiksu, Inc.)"

  s.description  = <<-DESC
                   Digital Fingerprints can be used for many purposes in Digital Advertising.
                   The primary use of the DFID is to track conversions. A typical process
                   is to record a click on an ad for an app with a particular DFID. Later
                   when a user launches the app you can compute the same DFID, make the
                   match, and presume that the click led to the installation of the app.
                   DESC

  s.homepage     = "https://github.com/fiksu/DFID"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Fiksu, Inc." => "info@fiksu.com" }
  s.social_media_url = "https://twitter.com/Fiksu"
  s.platform     = :ios, '6.0'
  s.frameworks   = ["MessageUI", "CoreTelephony", "UIKit"]
  s.source       = { :git => "https://github.com/fiksu/DFID.git", :tag => "7.0.0-alpha" }
  s.source_files = 'DFID/**/*.{h,m}'
  s.requires_arc = true
end
