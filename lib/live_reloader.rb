class LiveReloader
  RELOAD_FREQUENCY = 0.5 # seconds
  WATCH_FILES = "**/*.{rb,html,erb}"
  DO_NOT_WATCH_FILES = "test/**/*"

  def self.start(filename_to_reload: "bin/server")
    Thread.new do
      live_reloader = new(filename_to_reload:)

      loop do
        live_reloader.reload_if_files_changed
        sleep RELOAD_FREQUENCY
      end
    end
  end

  def initialize(filename_to_reload:)
    time_now = Time.now
    @start_time = time_now
    @last_reload_check = time_now
    @filename_to_reload = filename_to_reload
  end

  def reload_if_files_changed
    return unless files_changed?

    @start_time = Time.now
    puts "Files changed. Restarting server..."
    reload!
  end

  private

  def files_changed?
    (Dir.glob(WATCH_FILES) - Dir.glob(DO_NOT_WATCH_FILES)).any? do |file|
      File.mtime(file) > @start_time
    end
  end

  def reload!
    exec(@filename_to_reload)
  end
end
