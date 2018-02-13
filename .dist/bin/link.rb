#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby
require 'fileutils'

SRC = File.absolute_path('.dist/src')

ROOT = File.expand_path('~')

def ln(old, new)
  if File.exist? new and File.directory? new
    puts "#{new} already exist, and it's a folder, rm it."
    FileUtils.rm_rf new
  end
  FileUtils.ln_s old, new, { force: true }
end

def link(path)
  Dir.chdir path do
    if File.exist? '.link_folder'
      folder = File.expand_path('.')
      target = folder.gsub(SRC, ROOT)
      ln(folder, target)
    else
      all = Dir.glob("*", File::FNM_DOTMATCH) - %w[. ..]
      all.each do |f|
        if File.directory?(f)
          link f
        else
          file = File.absolute_path(f)
          target = file.gsub(SRC, ROOT)
          ln(file, target)
        end
      end
    end
  end
end

link(SRC)
