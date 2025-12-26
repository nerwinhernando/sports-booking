module SuperAdminAdministrate
  class AccountsController < SuperAdminAdministrateController
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

    def new
      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource_class.new),
      }
    end

    def edit
      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource),
      }
    end

    def create
      resource = resource_class.new(resource_params)

      if resource.save
        redirect_to(
          after_resource_created_path(resource),
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }, status: :unprocessable_entity
      end
    end

    def update
      if requested_resource.update(resource_params)
        redirect_to(
          after_resource_updated_path(requested_resource),
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }, status: :unprocessable_entity
      end
    end

    def destroy
      if requested_resource.destroy
        flash[:notice] = translate_with_resource("destroy.success")
      else
        flash[:error] = requested_resource.errors.full_messages.join("<br/>")
      end
      redirect_to after_resource_destroyed_path(requested_resource)
    end

    def activate
      if requested_resource.update(active: true)
        redirect_to super_admin_accounts_path, notice: "Account activated successfully"
      else
        redirect_to super_admin_accounts_path, alert: "Failed to activate account"
      end
    end

    def deactivate
      if requested_resource.update(active: false)
        redirect_to super_admin_accounts_path, notice: "Account deactivated successfully"
      else
        redirect_to super_admin_accounts_path, alert: "Failed to deactivate account"
      end
    end

    private

    def scoped_resource
      resource_class.all
    end

    def resource_class
      Account
    end

    helper_method :resource_class

    def dashboard
      @dashboard ||= dashboard_class.new
    end

    helper_method :dashboard

    def dashboard_class
      AccountDashboard
    end

    def requested_resource
      @requested_resource ||= scoped_resource.find(params[:id])
    end

    def resource_params
      params.require(resource_class.model_name.param_key)
            .permit(dashboard.permitted_attributes)
    rescue ActionController::ParameterMissing
      {}
    end

    def records_per_page
      params[:per_page] || 20
    end

    def order
      @order ||= Administrate::Order.new(
        params.fetch(:order, dashboard_class::COLLECTION_ATTRIBUTES.first.to_s),
        params.fetch(:direction, "asc"),
      )
    end

    helper_method :order

    def filter_resources(resources, search_term:)
      return resources if search_term.blank?

      Administrate::Search.new(
        resources,
        dashboard_class,
        search_term
      ).run
    end

    def apply_collection_includes(relation)
      resource_includes = dashboard.collection_includes
      return relation if resource_includes.empty?
      relation.includes(*resource_includes)
    end

    def paginate_resources(resources)
      resources.page(params[:_page]).per(records_per_page)
    end

    def after_resource_created_path(resource)
      [super_admin_namespace, resource]
    end

    def after_resource_updated_path(resource)
      [super_admin_namespace, resource]
    end

    def after_resource_destroyed_path(resource)
      [super_admin_namespace, resource_class]
    end

    def super_admin_namespace
      :super_admin
    end

    def translate_with_resource(key)
      I18n.t("administrate.controller.#{key}", resource: resource_class.model_name.human)
    rescue I18n::MissingTranslationData
      key.titleize
    end

    def show_search_bar?
      dashboard.attribute_types_for(
        dashboard_class::COLLECTION_ATTRIBUTES
      ).any? { |_name, attribute| attribute.searchable? }
    end

    helper_method :show_search_bar?

    def valid_action?(name, resource = resource_class)
      (%w[new show edit destroy] + _additional_valid_actions(resource)).include?(name.to_s) &&
        !workflow_state?(name)
    end

    def _additional_valid_actions(_resource)
      ["activate", "deactivate"]
    end

    def workflow_state?(action)
      false
    end

    helper_method :valid_action?
  end
end

# module SuperAdminAdministrate
#   class AccountsController < SuperAdminAdministrateController
#     include Administrate::Punditize

#     def index
#       search_term = params[:search].to_s.strip
#       resources = Administrate::Search.new(
#         scoped_resource,
#         dashboard_class,
#         search_term
#       ).run
#       resources = apply_collection_includes(resources)
#       resources = order.apply(resources)
#       resources = resources.page(params[:_page]).per(records_per_page)
#       page = Administrate::Page::Collection.new(dashboard, order: order)

#       render locals: {
#         resources: resources,
#         search_term: search_term,
#         page: page,
#         show_search_bar: show_search_bar?,
#       }
#     end

#     def show
#       render locals: {
#         page: Administrate::Page::Show.new(dashboard, requested_resource),
#       }
#     end

#     def new
#       render locals: {
#         page: Administrate::Page::Form.new(dashboard, resource_class.new),
#       }
#     end

#     def edit
#       render locals: {
#         page: Administrate::Page::Form.new(dashboard, requested_resource),
#       }
#     end

#     def create
#       resource = resource_class.new(resource_params)

#       if resource.save
#         redirect_to(
#           after_resource_created_path(resource),
#           notice: translate_with_resource("create.success"),
#         )
#       else
#         render :new, locals: {
#           page: Administrate::Page::Form.new(dashboard, resource),
#         }, status: :unprocessable_entity
#       end
#     end

#     def update
#       if requested_resource.update(resource_params)
#         redirect_to(
#           after_resource_updated_path(requested_resource),
#           notice: translate_with_resource("update.success"),
#         )
#       else
#         render :edit, locals: {
#           page: Administrate::Page::Form.new(dashboard, requested_resource),
#         }, status: :unprocessable_entity
#       end
#     end

#     def destroy
#       if requested_resource.destroy
#         flash[:notice] = translate_with_resource("destroy.success")
#       else
#         flash[:error] = requested_resource.errors.full_messages.join("<br/>")
#       end
#       redirect_to after_resource_destroyed_path(requested_resource)
#     end

#     def activate
#       if requested_resource.update(active: true)
#         redirect_to super_admin_accounts_path, notice: "Account activated successfully"
#       else
#         redirect_to super_admin_accounts_path, alert: "Failed to activate account"
#       end
#     end

#     def deactivate
#       if requested_resource.update(active: false)
#         redirect_to super_admin_accounts_path, notice: "Account deactivated successfully"
#       else
#         redirect_to super_admin_accounts_path, alert: "Failed to deactivate account"
#       end
#     end

#     private

#     def scoped_resource
#       resource_class.all
#     end

#     def resource_class
#       Account
#     end

#     def dashboard
#       @dashboard ||= dashboard_class.new
#     end

#     def dashboard_class
#       AccountDashboard
#     end

#     def requested_resource
#       @requested_resource ||= scoped_resource.find(params[:id])
#     end

#     def resource_params
#       params.require(resource_class.model_name.param_key)
#             .permit(dashboard.permitted_attributes)
#     end

#     def records_per_page
#       params[:per_page] || 20
#     end

#     def order
#       @order ||= Administrate::Order.new(
#         params.fetch(:order, "id"),
#         params.fetch(:direction, "desc"),
#       )
#     end

#     def apply_collection_includes(relation)
#       resource_includes = dashboard.collection_includes
#       return relation if resource_includes.empty?
#       relation.includes(*resource_includes)
#     end

#     def after_resource_created_path(resource)
#       super_admin_account_path(resource)
#     end

#     def after_resource_updated_path(resource)
#       super_admin_account_path(resource)
#     end

#     def after_resource_destroyed_path(resource)
#       super_admin_accounts_path
#     end

#     def translate_with_resource(key)
#       I18n.t("administrate.controller.#{key}", resource: resource_class.model_name.human)
#     end

#     def show_search_bar?
#       dashboard.attribute_types_for(
#         dashboard_class::COLLECTION_ATTRIBUTES
#       ).any? { |_name, attribute| attribute.searchable? }
#     end
#   end
# end

# module SuperAdminAdministrate
#   class AccountsController < Administrate::ApplicationController
#     before_action :authenticate_admin

#     def activate
#       requested_resource.update(active: true)
#       redirect_to super_admin_accounts_path, notice: "Account activated"
#     end

#     def deactivate
#       requested_resource.update(active: false)
#       redirect_to super_admin_accounts_path, notice: "Account deactivated"
#     end

#     private

#     def authenticate_admin
#       unless current_user&.super_admin?
#         redirect_to main_root_path, alert: 'Access denied'
#       end
#     end
#   end
# end
