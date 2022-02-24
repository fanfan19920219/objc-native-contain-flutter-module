# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# 添加模块所在路径
flutter_application_path = '../my_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'fixFlutter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # 安装Flutter模块
  install_all_flutter_pods(flutter_application_path)


  # Pods for fixFlutter

  target 'fixFlutterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'fixFlutterUITests' do
    # Pods for testing
  end

end
