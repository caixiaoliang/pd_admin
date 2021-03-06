class UploadWorker
  include Sidekiq::Worker

  def perform(file,total_count,key,role)
    import_worker = ProductImport.new(file,key,role)
    import_worker.progress_percentage.progress = {total_count: total_count,completed_count: 0}
    import_worker.work(&ProductImport.data_parse_by_role(role))
    puts "finished"
    import_worker.after_import
  end
  
end
