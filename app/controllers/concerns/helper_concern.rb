module HelperConcern extend ActiveSupport::Concern 
    def flatten_hash(obj, res={})
        obj.each do |key, value|
            if value.is_a?(ActionController::Parameters)
                flatted_hash = flatten_hash(value, {})
                if res.empty?
                    res = flatted_hash
                else
                    res.merge!(flatted_hash)
                end
            else
                res[key] = value
            end
        end
        res
    end    
end