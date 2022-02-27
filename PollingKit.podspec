Pod::Spec.new do |s|
    s.name = "PollingKit"
    s.version = "2.0.0"
    s.summary = "PollingKit provides a polling mechanism that respects callback delays."
    s.author = "Lukas Würzburger"
    s.license = { :type => "MIT" }
    s.homepage = "https://github.com/lukaswuerzburger/PollingKit"
    s.source = { :git => "https://github.com/lukaswuerzburger/PollingKit.git", :branch => "main" }
    s.source_files = "PollingKit/Sources/*.swift"
    s.ios.deployment_target = "10.0"
    s.ios.frameworks = 'Foundation'
    s.osx.deployment_target = "10.14"
    s.osx.frameworks = 'Foundation'
    s.requires_arc = true
    s.swift_version = "5.0"
end
