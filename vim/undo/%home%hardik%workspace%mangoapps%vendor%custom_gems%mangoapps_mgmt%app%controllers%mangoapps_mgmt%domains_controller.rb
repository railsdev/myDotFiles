Vim�UnDo� ��>����Mo M~��[�D�g�Y�6���{�J  �                                   V�"�     _�                      R        ����                                                                                                                                                                                                                                                                                                                                                             V�"�     �              �   L# **************************************************************************   I# C O P Y R I G H T   A N D   C O N F I D E N T I A L I T Y   N O T I C E   L# **************************************************************************   @# Copyright (c) 2007-2011 MangoSpring, Inc. All rights reserved.   ># This software contains valuable confidential and proprietary   ?# information of MangoSpring, Inc. and is subject to applicable   H# licensing agreements. Unauthorized access for any reason including but   H# not limited to reproduction,transmission or distribution of this file    5# and its contents is a violation of applicable laws.   L# **************************************************************************           :require_dependency "mangoapps_mgmt/application_controller"       module MangoappsMgmt   1  class DomainsController < ApplicationController           def index         params[:page] ||= 1         params[:per_page] ||= 10   ~      params[:method_name] = (params[:method_name].nil? || params[:method_name].blank?) ? "all_domains" : params[:method_name]   �      params[:method_name] = ['paid_domains', 'free_domains', 'cancelled_domains', 'mobile_domains', 'suspended_domains', 'all_domains'].include?(params[:method_name]) ? params[:method_name] : 'all_domains'         col = params[:col]         ord = params[:ord]   .      if params[:ord].present? && col.present?   (        order = "#{get_col(col)} #{ord}"   
      else   )        order = "domains.created_at desc"   	      end   C      logger.debug("Method name : #{params[:method_name].inspect}")   6      @billing_day = params[:select_billing_day] || ""   ?      @created_from = params[:select_domain_created_from] || ''             if params[:q].present?   �        @domains = Domain.search(params[:q]).reorder(order).paginate :per_page => params[:per_page].to_i , :page => params[:page].to_i   
      else   �        @domains = Domain.order(order).send(params[:method_name]).domain_billing_day(@billing_day).domain_created_from(@created_from).paginate :per_page => params[:per_page].to_i , :page => params[:page].to_i   	      end   X      @domain_type_counts = Domain.send(params[:method_name]).group(:created_from).count   4      @domain_count = @domain_type_counts.values.sum   !      if params[:format] == "csv"   -        CSV.open("domains.csv", "w") do |csv|   7          csv << ["Domain", "Name", "Email", "Created"]   #          @domains.each do |domain|                admin = domain.admin   )            admin_name = admin.try(:name)   "            if(!admin_name.blank?)   *              name = admin_name.split(' ')   "              admin_name = name[0]               end   p            csv << [domain.domain_key, admin_name, admin.try(:email_id), domain.created_at.strftime("%b/%d/%Y")]             end           end   R        send_file "domains.csv", :type => "text/csv", :disposition => "attachment"   	      end   N      render :action => "ecm_storage" if params[:method_name] == "ecm_storage"       end           def ecm_storage           end           def file_sync_setting   J      @domain_preference = DomainPreference.find_by_domain_id(params[:id])         render :layout => false       end           def file_sync_setting   J      @domain_preference = DomainPreference.find_by_domain_id(params[:id])         render :layout => false   	    end             def new         @domain = Domain.new       end           def create         @domain = Domain.new   R      @domain.domain_name = params[:domain_name] if  params[:domain_name].present?   V      @domain.domain_gui_name = params[:domain_name] if  params[:domain_name].present?   c      @domain.domain_email_name = params[:domain_email_name] if params[:domain_email_name].present?   H      @domain.domain_application_type = params[:domain_application_type]   !      if params[:email].present?    &        @domain.email = params[:email]           @licenses = 0   (        params[:product] = "MangoSuite"    H        params[:plan] = params[:plan] || PulseConstants::ENTERPRISE_PLAN   V        params[:domain_key] = params[:domain_key].present? ? params[:domain_key] : nil   W        params[:domain_url] = params[:domain_url].present? ? params[:domain_url] :  nil           @domain.params = params           if @domain.save   .          if params[:domain_type] == "private"   �            GlobalSetting.create_for_private_cloud(:licenses => params[:licenses].to_i, :billing => MConstants::NO, :private_cloud => MConstants::YES)   [            @domain.domain_preference.update_attributes(:show_adeptol_file_viewer => false)             end   J          if params[:domain_application_type] == PulseConstants::BOTH_APPS   �            int_app = DomainProduct.new(domain_id: @domain.id, plan: PulseConstants::SOCIAL_INTRANET_APP, product: 'MultipleApps')               int_app.save   �            collab_app = DomainProduct.new(domain_id: @domain.id, plan: PulseConstants::COLLABORATION_APP, product: 'MultipleApps')               collab_app.save             end   ,          flash[:notice] = "Domain Created."   *          return redirect_to(domains_path)           else   :          Rails.logger.error(@domain.errors.full_messages)   ^          flash[:error] = "Domain Creation Failed. #{@domain.errors.full_messages.join(", ")}"   (          return render :action => "new"           end         else     <        flash[:error] = "Please enter all fields to proceed"   &        return render :action => "new"   	      end       rescue Exception => e   9      logger.error "Mgmt/domain#create #{params[:email]}"         if @domain   1        logger.error @domain.errors.full_messages   '        if @domain.c_record_id.present?   !          @domain.delete_c_record           end   	      end   C      if e.class.to_s == "Connectors::DnsMadeEasyHook::CustomError"   $        @dns_made_easy_exception = e   �        flash[:error] = "Domain Creation Failed. Domain already exist in #{@dns_made_easy_exception.data_center.upcase} data center. Please visit <a href=\"#{@dns_made_easy_exception.url}\" target=\"_blank\">#{@dns_made_easy_exception.url}</a> ".html_safe   	      end   F      logger.error "Mgmt/domain#create #{e.message} \n #{e.backtrace}"   $      return render :action => "new"       end           def edit   (      @domain = Domain.find(params[:id])   P      @global_setting = GlobalSetting.find_by_prop_name(GlobalSetting::LICENSES)         if @global_setting   .        @licenses = @global_setting.prop_value         else    L        #not sure why we have this test....what are we trying to accomplish?   X        #flash[:error] = "Not allowed to edit the settings in a shared cloud deployment"   !        #redirect_to domains_path   	      end       end           def update   (      @domain = Domain.find(params[:id])         if params[:do].present?   *        @domain = Domain.find(params[:id])   #        if params[:do] == "suspend"   4          @domain.update_attribute(:suspended, true)           else   5          @domain.update_attribute(:suspended, false)           end   Y        flash[:notice] = "Domain #{params[:do] == 'suspend' ? 'suspended' : 'activated'}"   (        return redirect_to(domains_path)   	      end       end           def destroy   (      @domain = Domain.find(params[:id])   %      domain_key = @domain.domain_key         domain_id = @domain.id   C      Attachment.unscoped.where(:domain_id => domain_id).delete_all         if @domain.destroy   2        $domain_key_config_hash.delete(domain_key)   1        $domain_key_config_hash.delete(domain_id)   @        flash[:notice] = "Domain has been deleted successfully."   
      else   1        flash[:error] = "Domain deletion failed."   	      end         redirect_to domains_path           rescue Exception => e   a      Rails.logger.error("Mgmt::DomainController#destroy #{e.message} #{e.backtrace.join("\n")}")   A      flash[:error] = "Domain has not been deleted successfully."         redirect_to domains_path       end           def activate_sharepoint   �      @domain_content_repository = DomainContentRepository.find(:first, :conditions => {:domain_id => params[:id], :repository_type => PulseConstants::REPOSITORY_TYPE_SHAREPOINT})         begin   6        @domain_content_repository.activate_sharepoint   `        flash[:notice] = "Successfully Activated #{PulseConstants::REPOSITORY_TYPE_SHAREPOINT}."            redirect_to domains_path         rescue Exception => e   v        logger.error("Exception occurred while activating #{PulseConstants::REPOSITORY_TYPE_SHAREPOINT} #{e.message}")   \        flash[:error] = "Unable to Activate #{PulseConstants::REPOSITORY_TYPE_SHAREPOINTs}."            redirect_to domains_path   	      end       end           def coupons   +      @coupons = MangoappsMgmt::Coupons.all       end           def create_coupon         if params[:coupon_code]   0        expires_on = params[:expires_on].to_date   ^        status = expires_on && expires_on < Date.today ? "E" : "A"  #A => Active; E => Expired   (        params.merge!(:status => status)   m        @coupon = MangoappsMgmt::Coupons.new(params.except(:action, :controller, :authenticity_token, :utf8))           if @coupon.save   9          flash[:notice] = "Coupon created successfully."   5          redirect_to coupons_domains_path and return           else   R          flash[:error] = "Coupon code alreay exists. Choose another coupon code."   5          redirect_to coupons_domains_path and return           end   	      end         render :layout => false       end           def show_redeemed_domains   &      coupon_id = params[:coupon_code]   @      domain_coupons =  DomainCoupon.where(coupon_id: coupon_id)   $      @coupon_code = params[:coupon]   >      domain_ids = domain_coupons.map do |dc| dc.domain_id end   B      @domains = Domain.select("domain_url").where(id: domain_ids)         render :layout => false       end           def modify_or_delete_coupon   1      action_type = params[:action_type].downcase   &      coupon_ids = params[:coupon_ids]   i      MangoappsMgmt::Coupons.where(id: coupon_ids).update_all(status: "D") if action_type == "deactivate"   X      MangoappsMgmt::Coupons.where(id: coupon_ids).delete_all if action_type == "remove"         render json: true       end           def ecm_storage         redirect_to domains_path       end           def sync_form         @domain_id = params[:id]   (      @domain = Domain.find(params[:id])         render :layout => false       end           def sync_data   /      @domain = Domain.find(params[:domain_id])   ?      if @domain.storage_location == PulseConstants::STORAGE_S3           sync_s3_san   C      elsif @domain.storage_location == PulseConstants::STORAGE_SAN           sync_san_s3   	      end       end           #       # Sync S3 from SAN data       #       def sync_san_s3         @success = false   1      params[:ecm_repository][:is_default] = true   $      domain_id = params[:domain_id]         @message = ''   �      if(params[:ecm_repository][:s3_bucket_name].blank? || params[:ecm_repository][:s3_access_key].blank? || params[:ecm_repository][:s3_secret_key].blank?)   .        @message = 'All fields are mandatory.'   
      else           @success = true   	      end         if(@success)    <        access_key = params[:ecm_repository][:s3_access_key]   C        secret_access_key = params[:ecm_repository][:s3_secret_key]   >        bucket_name = params[:ecm_repository][:s3_bucket_name]   m        bucket = EcmRepository.get_s3_bucket("Custom S3 Bucket", access_key, secret_access_key, bucket_name)            if bucket.present?              client = bucket.client   v          san_repository = EcmRepository.find_by_domain_id_and_repository_type(domain_id, PulseConstants::STORAGE_SAN)   ,          san_path = san_repository.san_path   �          ecm_repository = EcmRepository.find_or_initialize_by_domain_id_and_repository_type(domain_id, PulseConstants::STORAGE_S3)    .          ecm_repository.domain_id = domain_id   )          domain = Domain.find(domain_id)   �          if ecm_repository.update_attributes(params[:ecm_repository]) && domain.update_attribute(:storage_location, PulseConstants::STORAGE_S3)    �            update_sql = "san_storage_url = REPLACE(san_storage_url, 'file://#{san_path}', '#{PROTOCOL}://#{bucket_name}.s3.amazonaws.com'), storage = 'S3', repository_id = #{ecm_repository.id}"     $            total_count = 0           �            total_count = total_count + Attachment.update_all(update_sql + ", streaming_url = CASE WHEN content_type_filter_id = 8 THEN san_storage_url ELSE NULL END, streaming_storage = storage, streaming_repository_id = repository_id, version_id = NULL, thumbnail_version_id = NULL, storage_url = CASE WHEN content_type_filter_id = 4 THEN storage_url ELSE san_storage_url END", ["storage = ? AND domain_id = ?", "SAN", domain_id])   �            total_count = total_count + AttachmentVersion.joins(:attachment).update_all(update_sql + ", attachment_versions.streaming_url = CASE WHEN attachment_versions.content_type = 'application/pdf' THEN attachment_versions.san_storage_url ELSE NULL END, attachment_versions.streaming_storage = attachment_versions.storage, attachment_versions.streaming_repository_id = attachment_versions.repository_id, attachment_versions.version_id = NULL, attachment_versions.thumbnail_version_id = NULL, attachment_versions.storage_url = CASE WHEN attachment_versions.content_type LIKE '%image%' THEN attachment_versions.storage_url ELSE attachment_versions.san_storage_url END", ["attachment_versions.storage = ? AND attachments.domain_id = ?", "SAN", domain_id])    �            total_count = total_count + Event.unscoped.update_all(update_sql, ["storage = ? and domain_id = ?", "SAN", domain_id])   �            total_count = total_count + EventPhoto.joins(:user).update_all(update_sql, ["storage = ? and domain_id = ?", "SAN", domain_id])                 �            total_count = total_count + Photo.joins(:user).update_all(update_sql, ["storage = ? and domain_id = ?", "SAN", domain_id])   �            total_count = total_count + ConversationUploadedContent.joins(:conversation).update_all(update_sql, ["storage = ? and domain_id = ?", "SAN", domain_id])   �            total_count = total_count + ApplicationAsset.joins(:application_category).update_all(update_sql, ["storage = ? and domain_id = ?", "SAN", domain_id])   N            JobQueue.update_all("status = 'Q'", ["domain_id = ?", domain_id])        {            # If total number of files updated are greater than zero then proceed for S3 import otherwise it's not required               if total_count > 0   T              # Assigning the key details to s3cfg and moving it to the San location   e              FileUtils.cp("#{Rails.root}/config/s3cfg.txt", "#{Rails.root}/config/copied_s3cfg.txt")   �              File.open(filename = "#{Rails.root}/config/copied_s3cfg.txt", "r+") { |file| file << File.read(filename).gsub(/access_key/,"access_key = #{access_key}")}   �              File.open(filename = "#{Rails.root}/config/copied_s3cfg.txt", "r+") { |file| file << File.read(filename).gsub(/secret_key/,"secret_key = #{secret_access_key}")}   �              `s3cmd -c #{Rails.root}/config/copied_s3cfg.txt sync --no-check-md5 #{san_path}/pulse s3://#{bucket_name}/pulse/#{domain.domain_key} > #{Rails.root}/tmp/s3_sync.out 2>&1 &`               end   ^            @message = "Successfully set the domain with storage as S3 and started syncing S3"             else               @success = false   1            @message = "Incorrect S3 credentials"             end           else             @success = false   0          @message = "Incorrect S3 credentials"            end    	      end       end           #       # Sync SAN from S3 data       #       def sync_s3_san         @success = false   1      params[:ecm_repository][:is_default] = true   $      domain_id = params[:domain_id]         @message = ''   3      if(params[:ecm_repository][:san_path].blank?)   .        @message = 'San path cannot be blank.'   
      else           @success = true   	      end         if(@success)    ,        access_key = $global[:S3_ACCESS_KEY]   E        secret_access_key = Base64.decode64($global[:S3_SECRET_KEY])    .        bucket_name = $global[:S3_BUCKET_NAME]   �        bucket = EcmRepository.get_s3_bucket($global[:ACCOUNT_NAME], $global[:S3_ACCESS_KEY], Base64.decode64($global[:S3_SECRET_KEY]), $global[:S3_BUCKET_NAME])            if bucket.present?              client = bucket.client   �          ecm_repository = EcmRepository.find_or_initialize_by_domain_id_and_repository_type(domain_id, PulseConstants::STORAGE_SAN)    .          ecm_repository.domain_id = domain_id   )          domain = Domain.find(domain_id)   �          if ecm_repository.update_attributes(params[:ecm_repository]) && domain.update_attribute(:storage_location, PulseConstants::STORAGE_SAN)    �            update_sql = "san_storage_url = REPLACE(san_storage_url, '#{PROTOCOL}://#{bucket_name}.s3.amazonaws.com', 'file://#{params[:ecm_repository][:san_path]}'), storage = 'SAN', repository_id = #{ecm_repository.id}"     $            total_count = 0           �            total_count = total_count + Attachment.update_all(update_sql + ", streaming_url = CASE WHEN content_type_filter_id = 8 THEN san_storage_url ELSE NULL END, streaming_storage = storage, streaming_repository_id = repository_id, version_id = version_no, storage_url = CASE WHEN content_type_filter_id = 4 THEN storage_url ELSE san_storage_url END", ["storage = ? AND domain_id =  ?", "S3", domain_id])    �            total_count = total_count + Event.unscoped.update_all(update_sql, ["storage = ? and domain_id = ?", "S3", domain_id])   �            total_count = total_count + EventPhoto.joins(:user).update_all(update_sql, ["storage = ? and domain_id = ?", "S3", domain_id])                 �            total_count = total_count + Photo.joins(:user).update_all(update_sql, ["storage = ? and domain_id = ?", "S3", domain_id])   �            total_count = total_count + ConversationUploadedContent.joins(:conversation).update_all(update_sql, ["storage = ? and domain_id = ?", "S3", domain_id])   �            total_count = total_count + ApplicationAsset.joins(:application_category).update_all(update_sql, ["storage = ? and domain_id = ?", "S3", domain_id])   N            JobQueue.update_all("status = 'Q'", ["domain_id = ?", domain_id])        c            # Download attachment versions manually in a separate thread as it can take longer time               Thread.new do                 version_ids = []   �              versions = AttachmentVersion.find(:all, :select => "attachment_versions.*", :joins => :attachment, :conditions => ["attachments.domain_id = ? and attachment_versions.storage = ?", domain_id, "S3"])   (              versions.each do |version|   ]                object_key = CommonUtils.get_object_key(version.san_storage_url, bucket.name)   &                if object_key.present?   �                  folder_key = "#{params[:ecm_repository][:san_path]}/pulse/#{domain.domain_key}/attachments/#{version.attachment_id}/#{version[:version_no]}"   *                  `mkdir -p #{folder_key}`                     begin   &                    # Download version   C                    file_path = "#{folder_key}/#{version.filename}"   �                    client.get_object({:bucket=> bucket.name, :key => object_key, :response_target => file_path, :version_id => version.version_id})       o                    # Update each record as the file paths would be diff and cannot do in bulk for all versions  �                    version.update_attibutes_without_timestamp!({:san_storage_url => "file://#{file_path}", :storage => "SAN", :repository_id => ecm_repository.id, :storage_url => version.is_image? ? version.storage_url : "file://#{file_path}", :streaming_url => version.is_pdf? ? "file://#{file_path}" : nil, :streaming_storage => "SAN", :streaming_repository_id => ecm_repository.id})                       C                    # Download thumbnails if thumbnails are present   <                    if version.thumbnail_version_id.present?   )                      # 50 x 50 thumbnail   F                      thumbnail_folder_key = folder_key + "/thumbnail"   8                      `mkdir -p #{thumbnail_folder_key}`       �                      version_name = version[:version_no] == 0 ? version.filename : version.filename.clone.insert(version.filename.rindex('.'), "_v#{version[:version_no]}")   K                      file_path = "#{thumbnail_folder_key}/#{version_name}"   j                      thumbnail_object_key = object_key.clone.insert(object_key.rindex("/"), "/thumbnail")   �                      thumbnail_object_key = thumbnail_object_key.clone.insert(thumbnail_object_key.rindex("."), "_v#{version[:version_no]}") if version[:version_no] > 0   }                      client.get_object({:bucket=> bucket.name, :key => thumbnail_object_key, :response_target => file_path})       %                      # 398 thumbnail   z                      file_path = "#{thumbnail_folder_key}/#{version_name.clone.insert(version_name.rindex('.'), '_398')}"   |                      thumbnail_398_object_key = thumbnail_object_key.clone.insert(thumbnail_object_key.rindex("."), "_398")   �                      client.get_object({:bucket=> bucket.name, :key => thumbnail_398_object_key, :response_target => file_path})       /                      # 700 or 2000px thumbnail   ~                      file_path = "#{thumbnail_folder_key}/#{version_name.clone.insert(version_name.rindex('.'), '_preview')}"   |                      thumbnail_object_key = thumbnail_object_key.clone.insert(thumbnail_object_key.rindex("."), "_preview")   }                      client.get_object({:bucket=> bucket.name, :key => thumbnail_object_key, :response_target => file_path})                       end   '                  rescue Exception => e   u                    Rails.logger.error("Exception occurred while copying S3 object : #{e.message} :: #{e.backtrace}")                     end                   end                 end               end   {            # If total number of files updated are greater than zero then proceed for S3 import otherwise it's not required               if total_count > 0   T              # Assigning the key details to s3cfg and moving it to the San location   e              FileUtils.cp("#{Rails.root}/config/s3cfg.txt", "#{Rails.root}/config/copied_s3cfg.txt")   �              File.open(filename = "#{Rails.root}/config/copied_s3cfg.txt", "r+") { |file| file << File.read(filename).gsub(/access_key/,"access_key = #{access_key}")}   �              File.open(filename = "#{Rails.root}/config/copied_s3cfg.txt", "r+") { |file| file << File.read(filename).gsub(/secret_key/,"secret_key = #{secret_access_key}")}   Y              `mkdir -p #{params[:ecm_repository][:san_path]}/pulse/#{domain.domain_key}`   �              `s3cmd -c #{Rails.root}/config/copied_s3cfg.txt sync --no-check-md5 s3://#{bucket_name}/pulse/#{domain.domain_key} #{params[:ecm_repository][:san_path]}/pulse > #{Rails.root}/tmp/s3_sync.out 2>&1 &`               end   a            @message = "Successfully set the domain with storage as SAN and started sync from S3"             else               @success = false   +            @message = "Incorrect SAN Path"             end           else             @success = false   =          @message = "Incorrect previous S3 Account Details"            end    	      end       end           def change_plan            p      @domain = params[:domain_type] == "T" ? TinytakePortal::Domain.find(params[:id]): Domain.find(params[:id])   &      unless @domain.tiny_take_domain?   <        domain_first_product = @domain.domain_products.first   2        next_plan = domain_first_product.next_plan   ^        @current_domain_plan ||= next_plan.present? ? next_plan : domain_first_product.plan      	      end         render :layout => false       end           def upgrade_plan   *        @domain = Domain.find(params[:id])   "      if @domain.tiny_take_domain?   :        @domain = TinytakePortal::Domain.find(params[:id])   '        if params[:upgrade_type] == "I"   J          @domain.domain_payment.update_plan(@domain.plans[params[:plan]])   P          @domain.domain_payment.update_attribute(:last_billed_at, DateTime.now)   B          @domain.update_attribute(:billing_day, DateTime.now.day)   >          flash[:notice] = "Domain Plan updated successfully "           else   3          @domain.mark_for_downgrade(params[:plan])   <          flash[:notice] = "Next Plan updated successfully "           end   
      else           old_plan = @domain.plan   V        params[:plan] = params[:plan].present? ?  params[:plan] : @domain.current_plan           success = false   .        if @domain.upgrade_plan(params[:plan])             @domain.reload   4          @domain.clear_discount_and_special_pricing   )          if !@domain.office_chat_domain?   T            @domain.update_future_invoices_if_already_marked_as_paid(params[:plan])              end   &          if params[:plan] =~ /annual/   r            @domain.billing_subscription.nil? ? @domain.create_billing_subscription : @domain.billing_subscription   �            @domain.billing_subscription.update_attributes(:billing_type => PulseConstants::BILLING_TYPE[:yearly], :initial_no_of_users => @domain.allowed_users.last_signin_at_ce_not_null.count)   L            # @domain.update_attribute(:last_annual_billing_date, Time.now )             end   $          if params[:plan] =~ /plus/   D            @domain.update_attribute(:last_annual_billing_date, nil)             end             success =true    7          flash[:notice] = "Plan changed successfully "           else   m          flash[:error] = "Failed to update your plan. Please contact support@mangospring.com for assistance"           end      m        if [PulseConstants::OFFICE_CHAT_BASIC, PulseConstants::BASIC_PLAN].include?(params[:plan]) && success   �          # @domain.order.clear_credit_card if @domain.order # DISABLED WIPING OUT CC INFO IF DOMAINS IS SUSPENDED OR DOWNGRADED TO BASIC           end   	      end         redirect_to domains_path       end           private           def get_col(col)         case col   S      when 'domains.allowed_users_count', 'domains.created_at', 'domains.suspended'           col   
      else           'domains.created_at'   	      end       end     end   end5��