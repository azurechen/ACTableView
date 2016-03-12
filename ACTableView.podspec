Pod::Spec.new do |s|

  s.name         = "ACTableView"
  s.version      = "0.2.2"
  s.summary      = "A faster and easier way to create a table and maintain your code."

  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/azurechen/ACTableView"
  s.license      = "MIT"
  s.author       = { "Azure Chen" => "azure517981@gmail.com" }
  s.source       = { :git => "https://github.com/azurechen/ACTableView.git", :tag => "v0.2.2" }

  s.source_files  = "Sources/**/*.swift"
  s.resource_bundles = {
    'ACTableViewPod' => [
        'Sources/**/*.xib'
    ]
  }

end
