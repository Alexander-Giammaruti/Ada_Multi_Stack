-- in file RepackStacks.adb

package body RepackStacks is

   package Int_IO is new Ada.Text_IO.Integer_IO(Integer); use Int_IO;

   function floor(X: float) return Integer is
      temp: Integer;
   begin
      temp:= Integer(X);
      if Float(temp) <= X then
         return temp;
      else
         return temp-1;
      end if;
   end floor;

   function GetName return Names is
      The_Name: Names;
   begin
      Get_Line(The_Name.Name, The_Name.Length);
      return The_Name;
   end GetName;

   procedure Print_Name(Output: File_Type; The_Name: Names) is begin
      for I in 1..The_Name.Length loop
         Put(Output, The_Name.Name(I));
      end loop;
   end Print_Name;

   procedure Print_Stacks(Output: File_Type; Stack: MultiStack;
                          L0: Integer; M: Integer) is
   begin
      Put(Output, "+");
      for I in L0+1..M loop
         For J in 1..Stack(I).Length/2-1 loop
            Put(Output, "-");
         end loop;
         If (Stack(I).Length rem 2) = 1 then
            Put(Output, "-");
         end if;
         Put(Output, I, 2);
         For J in 1..Stack(I).Length/2-1 loop
            Put(Output, "-");
         end loop;
      Put(Output, "+");
      end loop; Put_Line(Output, "");
      Put(Output, "|");
      for I in L0+1..M loop
         Print_Name(Output, Stack(I)); Put(Output, "|");
      end loop; Put_Line(Output, "");
      for I in L0+1..M loop
         Put(Output, "+");
         For J in 1..Stack(I).Length loop
            Put(Output, "-");
         end loop;
      end loop;
      put(Output, "+"); Put_Line(Output, "");
   end Print_Stacks;

   procedure Print_Top_Base(Output: File_Type; Arr: Top_Base) is
   begin
      Put(Output, "+");
      for I in 1..Arr'Length loop
         Put(Output, "--"); Put(Output, I, 2); Put(Output, "--+");
      end loop; Put_Line(Output, "");
      Put(Output, "|  ");
      for I in 1..Arr'Length loop
         Put(Output, Arr(I),2); Put(Output, "  |  ");
      end loop; Put_Line(Output, "");
      for I in 1..Arr'Length loop
         Put(Output, "+------");
      end loop;
      put(Output, "+"); Put_Line(Output, "");
   end Print_Top_Base;

   procedure Print_OldTop(Output: File_Type; Arr: Top_Base) is
   begin
      Put(Output, "+");
      for I in 1..Arr'Length-1 loop
         Put(Output, "--"); Put(Output, I, 2); Put(Output, "--+");
      end loop; Put_Line(Output, "");
      Put(Output, "|  ");
      for I in 1..Arr'Length-1 loop
         Put(Output, Arr(I),2); Put(Output, "  |  ");
      end loop; Put_Line(Output, "");
      for I in 1..Arr'Length-1 loop
         Put(Output, "+------");
      end loop;
      put(Output, "+"); Put_Line(Output, "");
   end Print_OldTop;


   procedure MoveStack(Stacks: in out MultiStack; Top: in out Top_Base;
                       Base: in out Top_Base; NewBase: Top_Base) is
      Delt: Integer;
      N: Integer:= Top'Length;
   begin
      --MoA1
      For J in 2..N loop
         if NewBase(J) < Base(J) then
            Delt:= base(J)-NewBase(J);
            For L in Base(J)+1..Top(J) loop
               Stacks(L-Delt):= Stacks(L);
               Stacks(L):= ("           ", 6);
            end loop;
            Base(J):= NewBase(J);
            Top(J):= Top(J)-Delt;
         end if;
      end loop;

      for J in reverse 2..N loop
         if NewBase(J) > Base(J) then
            Delt:= NewBase(J) - Base(J);
            For L in reverse Base(J)+1..Top(J) loop
               Stacks(L+Delt):= Stacks(L);
               Stacks(L):= ("           ", 6);
            end loop;
            Base(J):= NewBase(J);
            Top(J):= Top(J)+ Delt;
         end if;
      end loop;
   end MoveStack;
   procedure Reallocate(Stacks: in out MultiStack; Top: in out Top_Base;
                        Base: in out Top_Base; OneArray: in out Top_Base;
                        K: Integer; X: Names) is
      N: Integer:= Top'Length;
      MinSpace: Integer:= floor(Float(Base(N+1)-Base(1)) * 0.05);
      AvailSpace, TotalInc, J: Integer;
      EqualAllocate:Float:= 0.13;
      GrowthAllocate, Alpha, Beta, Sigma, Tau: FLoat;
   begin
      -- ReA1:
      AvailSpace:= Base(N+1) - Base(1);
      TotalInc:= 0;
      J:= N;
      while J > 0 loop
         AvailSpace:= AvailSpace - (Top(J) - Base(J));
         if Top(J) > OneArray(J) then
            OneArray(J+1):= Top(J) - OneArray(J);
            TotalInc:= TotalInc + OneArray(J+1);
         else
            OneArray(J+1):= 0;
         end if;
         J:= J - 1;
      end loop;
      -- end ReA1

      --ReA2
      if AvailSpace < MinSpace-1 then
         raise Program_Error with "Available space has fallen below 5%: Program Terminating ";

      end if;

      -- ReA3
      GrowthAllocate:= 1.0-EqualAllocate;
      Alpha:= EqualAllocate*Float(AvailSpace)/Float(N);

      --ReA4
      Beta:= GrowthAllocate*Float(AvailSpace)/Float(TotalInc);

      --ReA5
      OneArray(1):= Base(1); Sigma:= 0.0;
      for J in 2..N loop
         Tau:= Sigma + Alpha + Float(OneArray(J)) * Beta;
         OneArray(J):= OneArray(J-1) + (Top(J-1) - Base(J-1)) + floor(Tau) - floor(Sigma);
         Sigma:= Tau;
      end loop;

      --ReA6
      Top(K):= Top(K)-1;
      MoveStack(Stacks, Top, Base, OneArray);

      Top(K):= Top(K)+1;
      Stacks(Top(K)):= X;
      for J in 1..N loop
         OneArray(J):= Top(J);
      end loop;

   end Reallocate;

   procedure Push(Output: File_Type; Stack: in out MultiStack;
                  Top: in out Top_Base; Base: in out Top_Base;
                  OldTop: in out Top_Base; K: Integer; X: Names) is
      N: Integer:= Top'Length;
   begin
      Top(K):= Top(K)+1;
      if Top(K) > Base(K+1) then
         Put_Line("Overflow!");
         Put(Output, "Overflow at push "); Print_Name(Output, X); Put(Output, " into stack");
         Put(Output, K,2); Put_Line(Output, "");
         Put_Line(Output, "Stacks at overflow:");
         Print_Stacks(Output, Stack, Base(1), Base(N+1));
         Put_Line(Output, "Bases at overflow:");
         Print_Top_Base(Output, Base);
         Put_Line(Output, "Tops at overflow:");
         Print_Top_Base(Output, Top);
         Put_Line(Output, "Old Tops at overflow:");
         Print_OldTop(Output, OldTop); Put_Line(Output, "");
         Reallocate(Stack, Top, Base, OldTop, K, X);
         Put_Line(Output, "Stacks after overflow resolved:");
         Print_Stacks(Output, Stack, Base(1), Base(N+1));
         Put_Line(Output, "Bases after overflow resolved:");
         Print_Top_Base(Output, Base);
         Put_Line(Output, "Tops after overflow resolved:");
         Print_Top_Base(Output, Top); Put_Line(Output, "");
      else
         Stack(Top(K)):= X;
      end if;
   end Push;

   function Pop
     (Stack: in out MultiStack; Top: in out Top_Base;
      Base: in out Top_Base; K: Integer) return Names is
      Y: Names;
   begin
      if Top(K) = Base(K) then
         Put_Line("Stack underflow!");
         Y.Name:= "Underflow! ";
         return Y;
      else
         Y:= Stack(Top(K));
         Top(K):=Top(K)-1;
         return Y;
      end if;
   end Pop;

   procedure Initialize_Stacks(Stacks: in out MultiStack; Top: in out Top_Base;
                               Base: in out Top_Base; OneArray:  in out Top_Base;
                               L0: Integer; M: Integer; N: Integer) is
   begin
      For I in L0+1..M loop
         Stacks(I):= ("           ", 6);
      end loop;

      for J in 1..N+1 loop
         If J < N+1 then
            Top(J):= floor(Float(J-1)/Float(N)*Float(M-L0)) + L0;
            Base(J):= floor(Float(J-1)/Float(N)*Float(M-L0)) + L0;
            OneArray(J):= Top(J);
         else
            Base(J):= floor(Float(J-1)/Float(N)*Float(M));
         end if;
      end loop;
   end Initialize_Stacks;

end RepackStacks;
