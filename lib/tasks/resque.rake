# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do

  task :setup => :environment

  task :setup_schedule => :setup do
    require 'resque-scheduler'

    # Resque::Scheduler.dynamic = true

    Resque.schedule = YAML.load_file('config/resque_schedule.yaml')

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, something like this:
    #require 'app/jobs'
  end

  task :scheduler_setup => :setup_schedule
end
