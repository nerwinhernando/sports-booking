module SuperAdminAdministrate
  class UsersController < SuperAdminAdministrateController
    def index
      search_term = params[:search].to_s.strip
      resources = filter_resources(scoped_resource, search_term: search_term)
      resources = apply_collection_includes(resources)
      resources = order.apply(resources)
      resources = paginate_resources(resources)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
        filters: {},
      }
    end

    def show
      render locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource),
      }
    end

    def edit
      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource),
      }
    end

    def update
      if requested_resource.update(resource_params)
        redirect_to(
          [:super_admin, requested_resource],
          notice: "User updated successfully",
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }, status: :unprocessable_entity
      end
    end

    def toggle_active
      # Toggle active status if needed
      redirect_to super_admin_users_path, notice: "User updated"
    end

    private

    def scoped_resource
      resource_class.all
    end

    def resource_class
      User
    end

    helper_method :resource_class

    def dashboard
      @dashboard ||= UserDashboard.new
    end

    helper_method :dashboard

    def dashboard_class
      UserDashboard
    end

    def requested_resource
      @requested_resource ||= scoped_resource.find(params[:id])
    end

    def resource_params
      params.require(:user).permit(dashboard.permitted_attributes)
    rescue ActionController::ParameterMissing
      {}
    end

    def records_per_page
      params[:per_page] || 20
    end

    def order
      @order ||= Administrate::Order.new(
        params.fetch(:order, "id"),
        params.fetch(:direction, "asc"),
      )
    end

    helper_method :order

    def filter_resources(resources, search_term:)
      return resources if search_term.blank?
      Administrate::Search.new(resources, dashboard_class, search_term).run
    end

    def apply_collection_includes(relation)
      resource_includes = dashboard.collection_includes
      return relation if resource_includes.empty?
      relation.includes(*resource_includes)
    end

    def paginate_resources(resources)
      resources.page(params[:_page]).per(records_per_page)
    end

    def show_search_bar?
      dashboard.attribute_types_for(
        dashboard_class::COLLECTION_ATTRIBUTES
      ).any? { |_name, attribute| attribute.searchable? }
    end

    helper_method :show_search_bar?

    def valid_action?(name, resource = resource_class)
      (%w[show edit destroy] + ["toggle_active"]).include?(name.to_s)
    end

    helper_method :valid_action?
  end
end
