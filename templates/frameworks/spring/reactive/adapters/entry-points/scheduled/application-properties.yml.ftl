# Scheduled task configuration for ${adapterName}
scheduled:
  ${adapterName?lower_case}:
    # Cron expression: runs every 5 minutes by default
    # Format: second minute hour day month weekday
    # Examples:
    #   0 */5 * * * *  - Every 5 minutes
    #   0 0 * * * *    - Every hour
    #   0 0 0 * * *    - Every day at midnight
    #   0 0 9 * * MON-FRI - Every weekday at 9 AM
    cron: "0 */5 * * * *"
    
    # Alternative: Fixed delay (milliseconds) - waits this long after previous execution completes
    # fixed-delay: 300000  # 5 minutes
    
    # Alternative: Fixed rate (milliseconds) - executes at this interval regardless of previous execution
    # fixed-rate: 300000  # 5 minutes
    
    # Enable/disable the scheduled task
    enabled: true
