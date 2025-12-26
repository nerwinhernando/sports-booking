module Administrate
  module ApplicationControllerConcern
    def valid_action?(name, resource = resource_class)
      (["index", "show", "new", "edit", "create", "update", "destroy"] + _additional_valid_actions(resource)).include?(name.to_s)
    end

    def _additional_valid_actions(resource)
      []
    end
  end
end
