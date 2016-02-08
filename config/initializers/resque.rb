log_path = File.join Rails.root, 'log'

config = {
folder: log_path, # destination folder
class_name: Logger, # logger class name
class_args: [ 'daily', 1.kilobyte ], # logger additional parameters
level: Logger::DEBUG, # optional
}

Resque.logger_config = config
