class AddFriendlyIdToJobs < ActiveRecord::Migration[5.0]
  def change
     add_column :jobs, :friendly_id, :string
     add_index :jobs, :friendly_id, :unique => true

     Job.find_each do |e|
       e.update( :friendly_id => SecureRandom.uuid )
     end
  end
end
