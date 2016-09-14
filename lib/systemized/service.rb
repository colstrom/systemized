require_relative 'journal'

module Systemized
  class Service
    attr_reader :service, :options

    def initialize(service, **options)
      @service = service
      @options = options
      self
    end

    def journal
      @journal ||= Journal.new service
    end

    def command
      @options.fetch(:command) { 'systemctl' }
    end

    def quiet?
      @options.fetch(:quiet) { true }
    end

    def arguments
      @arguments ||= [
        ('--quiet' if quiet?)
      ].compact.join(' ')
    end

    def enabled?
      system("#{command} #{arguments} is-enabled #{service}")
    end

    def active?
      system("#{command} #{arguments} is-active #{service}")
    end

    def failed?
      system("#{command} #{arguments} is-failed #{service}")
    end

    def stop
      `#{command} #{arguments} stop #{service}`
    end

    def start
      `#{command} #{arguments} start #{service}`
    end
  end
end
