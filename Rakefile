include FileUtils::Verbose

namespace :test do
  desc 'Prepare tests'
  task :prepare do
  end

  desc 'Run the unit tests'
  task ios: :prepare do
    run('test', 'PollingKit', 'Debug', 'iPhone 7', '10.3.1')
    run('test', 'PollingKit', 'Debug', 'iPhone 8', '11.4')
    run('test', 'PollingKit', 'Debug', 'iPhone Xs', '12.4')
    run('test', 'PollingKit', 'Debug', 'iPhone SE (2nd generation)', '13.6')
    run('test', 'PollingKit', 'Debug', 'iPhone SE (2nd generation)', '14.5')
    run('test', 'PollingKit', 'Debug', 'iPhone SE (2nd generation)', '15.2')
  end

  desc 'Build the Demo App'
  task ios_example: :prepare do
    run('build', 'PollingKitDemo', 'Release', 'iPhone SE (2nd generation)', '13.6')
  end
end

namespace :package_manager do
  desc 'Prepare tests'
  task :prepare do
  end

  desc 'Builds the project with the Swift Package Manager'
  task spm: :prepare do
    sh("swift build \
    -Xswiftc \"-sdk\" -Xswiftc \"\`xcrun --sdk iphonesimulator --show-sdk-path\`\" \
    -Xswiftc \"-target\" -Xswiftc \"x86_64-apple-ios13.0-simulator\"") rescue nil
    package_manager_failed('Swift Package Manager') unless $?.success?
  end
end


desc 'Run the tests'
task :test do
  Rake::Task['test:ios'].invoke
  Rake::Task['test:ios_example'].invoke
  Rake::Task['package_manager:spm'].invoke
end

task default: 'test'

private

def run(operation, scheme, configuration, device, os)
    sh("xcodebuild -workspace PollingKit.xcworkspace -scheme '#{scheme}' -sdk 'iphonesimulator' -destination 'platform=iOS Simulator,name=#{device},OS=#{os}' -configuration #{configuration} clean #{operation} | xcpretty") rescue nil
    if $?.success?
        succeeded("#{device}, #{os}", operation)
    else
        failed("#{device}, #{os}", operation)
    end
end

def failed(platform, subject)
  puts red("#{platform} #{subject} failed.")
  exit $?.exitstatus
end

def succeeded(platform, subject)
  puts green("#{platform} #{subject} succeeded.")
end

def red(string)
  "\033[0;31m#{string}\033[0m"
end

def green(string)
  "\033[0;32m#{string}\033[0m"
end
