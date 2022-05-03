USE [CHUNGKHOAN]
GO

/****** Object:  Trigger [dbo].[triggerLenhDat]    Script Date: 03/05/2022 11:17:41 CH ******/
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
				select TOP (3) * into #TempTable from [dbo].[LENHDAT]
				where LOAIGD = 'M'  and SOLUONG > 0 and MACP  = @MaCP and CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE)
				order by GIADAT DESC,NGAYDAT
				
				set @Count = (SELECT COUNT(*) FROM #TempTable)
				if (@Count>=1)
					begin
						SELECT top 1 @GiaTemp = GIADAT, @SoLuongTemp = SOLUONG FROM #TempTable 
						UPDATE [dbo].[BangGiaTrucTuyen]
						SET GiaMua1 =  @GiaTemp, 
						SoLuongMua1 = @SoLuongTemp
						WHERE MaCP=@MaCP;
					end
				if (@Count>=2)
					begin 
						SELECT top 2 @GiaTemp = GIADAT, @SoLuongTemp = SOLUONG FROM #TempTable 
						UPDATE [dbo].[BangGiaTrucTuyen]
						SET GiaMua2 = @GiaTemp,
						SoLuongMua2 = @SoLuongTemp
						WHERE MaCP=@MaCP;
					end
				if (@Count=3)
					begin 
						SELECT top 3 @GiaTemp = GIADAT, @SoLuongTemp = SOLUONG FROM #TempTable 
						UPDATE [dbo].[BangGiaTrucTuyen]
						SET GiaMua3 =  @GiaTemp,
						SoLuongMua3 = @SoLuongTemp
						WHERE MaCP=@MaCP;
					end
				--select * from [dbo].[BangGiaTrucTuyen]
			end
		else 
			begin 
				select TOP (3) * into #TempTableB from [dbo].[LENHDAT]
				where LOAIGD = 'B'  and SOLUONG > 0 and MACP  = @MaCP and CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE)
				order by GIADAT ASC,NGAYDAT
				set @Count = (SELECT COUNT(*) FROM #TempTableB)
				select * from #TempTableB
				if (@Count>=1)
					begin 
						SELECT top 1 @GiaTemp = GIADAT, @SoLuongTemp = SOLUONG FROM #TempTableB
						UPDATE [dbo].[BangGiaTrucTuyen]
						SET GiaBan1 =  @GiaTemp, 
						SoLuongBan1 = @SoLuongTemp
						WHERE MaCP=@MaCP;
					end
				if (@Count>=2)
					begin 
						SELECT top 2 @GiaTemp = GIADAT, @SoLuongTemp = SOLUONG FROM #TempTableB
						UPDATE [dbo].[BangGiaTrucTuyen]
						SET GiaBan2 = @GiaTemp ,
						SoLuongBan2 = @SoLuongTemp
						WHERE MaCP=@MaCP;
					end
				if (@Count=3)
					begin 
						SELECT top 3 @GiaTemp = GIADAT, @SoLuongTemp = SOLUONG FROM #TempTableB
						UPDATE [dbo].[BangGiaTrucTuyen]
						SET GiaBan3 =  @GiaTemp,
						SoLuongBan3 = @SoLuongTemp
						WHERE MaCP=@MaCP;
					end
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

