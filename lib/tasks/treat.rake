require 'treat'

namespace :treat do
  desc "install treat dependencies"
  task install: :environment do
    Treat::Core::Installer.install 'english'
    Treat::Core::Installer.install 'spanish'
  end

end
