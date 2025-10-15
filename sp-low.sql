CREATE PROCEDURE proc_low (@proj_id int, @success_flag int)
AS 
declare @log_id int
declare @rundate datetime
declare @step1 int
declare @event_message varchar(500)
set @rundate=getDate()

begin
set @success_flag=0
	begin try

		begin transaction logme;
			exec inspire.create_log_entry  'spir_refresh_impacted_lines', @rundate, null, 'REFR_IMPACT_A', 'STARTED', 'MESSAGE', @proj_id ,@log_id output
		commit transaction logme;
	
		begin transaction updatea
			update p1
			set mark='I'
			from table_parts p1
			inner join table_refresh_data rd
			on (rd.material_code = p1.material_code
			and rd.processed is null
			and rd.[action]='A'
			and rd.spir_project_id=p1.spir_project_id)
			where p1.spir_project_id=@proj_id
			and p1.mark is null
			
			set @step1 = @@ROWCOUNT

			exec inspire.add_log_details @log_id, @proj_id,@step1,null,null,null,null,null,null,null,null
		commit transaction updatea;

		begin transaction logme;
			set @rundate=getDate()
			exec inspire.update_log_entry @log_id, 'COMPLETED', 'MESSAGE'
		commit transaction logme;		

	end TRY
	begin catch
		set @event_message = ERROR_MESSAGE()
	set @success_flag=-1			
		exec inspire.update_log_entry @log_id, @event_message, 'ERROR'
		exec inspire.update_inspire_project_proc @proj_id		

	end catch
end;