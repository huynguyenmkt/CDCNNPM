USE [CHUNGKHOAN]
GO

/****** Object:  Trigger [dbo].[triggerLenhDat]    Script Date: 04/05/2022 8:09:24 CH ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[triggerLenhDat] ON [dbo].[LENHDAT]
AFTER  INSERT, UPDATE
AS 
  BEGIN
	declare @MaCP nchar(7), @LoaiGD nchar(1), @GiaDat float,@SoLuong int,@Count int,@GiaTemp float, @SoLuongTemp int
	set @LoaiGD =  (select LOAIGD from inserted)
	set @MaCP = (select MACP from inserted)
	set @GiaDat = (select GIADAT from inserted)
	set @SoLuong = (select SOLUONG from inserted)

	if EXISTS (SELECT MaCP FROM [dbo].[BangGiaTrucTuyen] WHERE MaCP=@MaCP)
	begin 
		if (@LoaiGD='M')
			begin
				DECLARE cursorLenhM CURSOR FOR
				select TOP (3) GIADAT,SOLUONG from [dbo].[LENHDAT]
				where LOAIGD = 'M'  and SOLUONG > 0 and MACP  = @MaCP and CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE)
				order by GIADAT DESC,NGAYDAT

				Open cursorLenhM
				DECLARE @dem int
				set @dem = 0
				FETCH NEXT FROM cursorLenhM INTO @GiaTemp, @SoLuongTemp
				WHILE @@FETCH_STATUS = 0          
				BEGIN
					set @dem = @dem+1
					if(@dem = 1)
						begin
							UPDATE [dbo].[BangGiaTrucTuyen]
							SET GiaMua1 =  @GiaTemp, 
							SoLuongMua1 = @SoLuongTemp
							WHERE MaCP=@MaCP;
						end
					if(@dem = 2)
						begin
							UPDATE [dbo].[BangGiaTrucTuyen]
							SET GiaMua2 = @GiaTemp,
							SoLuongMua2 = @SoLuongTemp
							WHERE MaCP=@MaCP;
						end
					if(@dem = 3)
						begin
							UPDATE [dbo].[BangGiaTrucTuyen]
							SET GiaMua3 =  @GiaTemp,
							SoLuongMua3 = @SoLuongTemp
							WHERE MaCP=@MaCP;
						end
					FETCH NEXT FROM cursorLenhM INTO @GiaTemp, @SoLuongTemp
				END
				CLOSE cursorLenhM  
				DEALLOCATE cursorLenhM
			end
		else 
			begin 
				DECLARE cursorLenhB CURSOR FOR
				select TOP (3) GIADAT,SOLUONG from [dbo].[LENHDAT]
				where LOAIGD = 'B'  and SOLUONG > 0 and MACP  = @MaCP and CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE)
				order by GIADAT ASC,NGAYDAT

				Open cursorLenhB
				DECLARE @dem2 int
				set @dem2 = 0
				FETCH NEXT FROM cursorLenhB INTO @GiaTemp, @SoLuongTemp
				WHILE @@FETCH_STATUS = 0          
				BEGIN
					set @dem2 = @dem2+1
					if(@dem2 = 1)
						begin
							UPDATE [dbo].[BangGiaTrucTuyen]
							SET GiaBan1 =  @GiaTemp, 
							SoLuongBan1 = @SoLuongTemp
							WHERE MaCP=@MaCP;
						end
					if(@dem2= 2)
						begin
							UPDATE [dbo].[BangGiaTrucTuyen]
							SET GiaBan2 = @GiaTemp ,
							SoLuongBan2 = @SoLuongTemp
							WHERE MaCP=@MaCP;
						end
					if(@dem2 = 3)
						begin
							UPDATE [dbo].[BangGiaTrucTuyen]
							SET GiaBan3 =  @GiaTemp,
							SoLuongBan3 = @SoLuongTemp
							WHERE MaCP=@MaCP;
						end
					FETCH NEXT FROM cursorLenhB INTO @GiaTemp, @SoLuongTemp
				END
				CLOSE cursorLenhB  
				DEALLOCATE cursorLenhB
			end
	end 
	else 
		begin 
			if (@LoaiGD  ='M')
				begin
					INSERT INTO [dbo].[BangGiaTrucTuyen] (MaCP, GiaMua1, SoLuongMua1)
					VALUES (@MaCP,@GiaDat,@SoLuong);
				end
			else 
				begin
					INSERT INTO [dbo].[BangGiaTrucTuyen] (MaCP, GiaBan1, SoLuongBan1)
					VALUES (@MaCP,@GiaDat,@SoLuong);
				end
		end 
  END
GO

ALTER TABLE [dbo].[LENHDAT] ENABLE TRIGGER [triggerLenhDat]
GO

