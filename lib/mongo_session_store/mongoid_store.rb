begin
  require 'mongoid'
  require 'mongo_session_store/mongo_store_base'

  module ActionDispatch
    module Session
      class MongoidStore < MongoStoreBase

        class Session
          include Mongoid::Document
          include Mongoid::Timestamps
          self.collection_name = MongoSessionStore.collection_name

          field :user_id => String

          if respond_to?(:identity)
            # pre-Mongoid 3
            identity :type => String
          else
            field :_id, :type => String
          end

          field :data, :type => BSON::Binary, :default => BSON::Binary.new(Marshal.dump({}))

          def initialize(arg)
            super(arg)
            user_id = current_user.id.to_s
          end
        end

        private
        def pack(data)
          BSON::Binary.new(Marshal.dump(data))
        end
      end
    end
  end

  MongoidStore = ActionDispatch::Session::MongoidStore

rescue LoadError
end
