Pod::Spec.new do |s|
    s.name = "PollingController"
    s.version = "1.1.0"
    s.summary = "PollingController provides a polling mechanism that respects callback delays."
    s.author = "Lukas Würzburger"
    s.license = { :type => "MIT" }
    s.homepage = "https://github.com/lukaswuerzburger/PollingController"
    s.source = { :git => "https://github.com/lukaswuerzburger/PollingController.git", :tag => "1.1.0" }
    s.source_files = "PollingController/Sources/*.swift"
    s.ios.deployment_target = "10.0"
    s.ios.frameworks = 'Foundation'
    s.osx.deployment_target = "10.14"
    s.osx.frameworks = 'Foundation'
    s.requires_arc = true
    s.swift_version = "5.0"
end
