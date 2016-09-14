module Systemized
  class Journal
    attr_reader :unit, :options

    def initialize(unit, **options)
      @unit = unit
      @options = options
      self
    end

    def quiet?
      @quiet ||= options.fetch(:quiet) { true }
    end

    def output
      @output ||= options.fetch(:output) { 'short-iso' }
    end

    def utc?
      @utc ||= options.fetch(:utc) { true }
    end

    def lines
      @lines ||= options.fetch(:lines) { 10 }
    end

    def command
      @command ||= options.fetch(:command) { 'journalctl' }
    end

    def arguments
      @arguments ||= [
        "--unit #{unit}",
        ('--quiet' if quiet?),
        "--output #{output}",
        ('--utc' if utc?)
      ].compact.join(' ')
    end

    def read(entries = lines)
      `#{command} #{arguments} --lines #{entries}`.lines
    end
  end
end
