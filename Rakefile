REPOSITORY_ID = "yukihr/fjord_intern"
REPOSITORY = if ENV['GH_TOKEN']
    "https://$GH_TOKEN@github.com/#{REPOSITORY_ID}"
  else
    "git@github.com:#{REPOSITORY_ID}.git"
  end
PUBLISH_BRANCH = 'gh-pages'
DEST_DIR = 'build'

def initialize_repository(repository, branch)
  require 'fileutils'

  if Dir["#{DEST_DIR}/.git"].empty?
    FileUtils.rm_rf DEST_DIR
    system "git clone --quiet #{repository} #{DEST_DIR} 2> /dev/null"
  end

  Dir.chdir DEST_DIR do
    sh "git checkout --orphan #{branch}"
  end
end

def update_repository(branch)
  Dir.chdir DEST_DIR do
    sh 'git fetch origin'
    sh "git reset --hard origin/#{branch}"
  end
end

def build
  sh 'bundle exec middleman build'
end

def clean
  require 'fileutils'

  Dir["#{DEST_DIR}/*"].each do |file|
    FileUtils.rm_rf file
  end
end

def push_to(repository, branch)
  sha1, _ = `git log -n 1 --oneline`.strip.split(' ')

  Dir.chdir DEST_DIR do
    if branch == PUBLISH_BRANCH
      travis_settings = <<"EOT"
branches:
  except:
    - #{PUBLISH_BRANCH}
EOT
      File.write(".travis.yml", travis_settings)
    end
    sh 'git add -A'
    sh "git commit -m 'Update with #{sha1}'"
    system "git push --quiet #{repository} #{branch} 2> /dev/null"
  end
end

desc 'Setup origin repository for GitHub pages'
task :setup do
  initialize_repository REPOSITORY, PUBLISH_BRANCH
  update_repository PUBLISH_BRANCH
end

desc 'Clean built files'
task :clean do
  clean
end

desc 'Build sites'
task :build do
  clean
  build
end

desc 'Publish website'
task :publish do
  push_to REPOSITORY, PUBLISH_BRANCH
end
