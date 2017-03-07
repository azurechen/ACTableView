Pod::Spec.new do |s|

  s.name         = "ACTableView"
  s.version      = "0.4.0"
  s.summary      = "A faster and easier way to create a table and maintain your code."

  s.description  = <<-DESC
                   A faster and easier way to create a table and maintain your code.
                   DESC

  s.homepage     = "https://github.com/azurechen/ACTableView"
  s.license      = "MIT"
  s.author       = { "azurechen" => "azure517981@gmail.com" }
  s.source       = { :git => "https://github.com/azurechen/ACTableView.git", :tag => s.version.to_s }

  s.source_files  = "Sources/**/*.swift"
  s.resource_bundles = {
    'ACTableView' => [
        'Sources/**/*.xib'
    ]
  }

end
