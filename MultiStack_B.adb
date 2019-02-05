-- in file MultiStack_C.adb

with Ada.Text_IO; use Ada.Text_IO;
with Ada.IO_Exceptions;
with RepackStacks; use RepackStacks;

procedure MultiStack_B is
   package Int_IO is new Ada.Text_IO.Integer_IO(Integer); use Int_IO;

   type Operations is (I1, I2, I3, I4, I5, I6, I7, I8, I9, I10,
                       D1, D2, D3, D4, D5, D6, D7, D8, D9, D10,
                       Stop);
   subtype PushCommand is Operations range I1..I10;
   subtype PopCommand is Operations range D1..D10;

   package Operations_IO is new Ada.Text_IO.Enumeration_IO(Operations);
   Use Operations_IO;

   LB, UB, L0, N, M: Integer;

begin
   Put("Lower bound of array?: "); Get(LB);
   Put("Upper bound of array?: "); Get(UB);
   Put("L0 Address?: "); Get(L0);
   Put("M address?: "); Get(M);
   Put("Number of Stacks?: "); Get(N);Skip_Line;


   declare
      Operation : Operations;
      Top: Top_Base(1.. N);
      Base: Top_Base(1..N+1);
      OneArray: Top_Base(1..N+1);
      Stacks: MultiStack(LB..UB);
      The_Name: Names;
      Output_File: File_Type;
   begin
      Initialize_Stacks(Stacks, Top, Base, OneArray, L0, M, N);
      Put_Line("Stacks Initialized");
      Create(Output_File, Out_File, "Output.txt");
      Put_Line(Output_File, "In File Output.txt"); Put_Line(Output_File, "");
      Put("Operation: ");
      Get(Operation);Skip_Line;
      while Operation /= Stop loop
         case Operation is
            When PushCommand =>
               Put("Name: "); The_Name:= GetName;
               Push(Output_File, Stacks, Top, Base, OneArray, PushCommand'Pos(Operation)+1, The_Name);
               Print_Name(Output_File, The_Name); Put(Output_File, " pushed into stack ");
               Put(Output_File, PushCommand'Pos(Operation)+1,2); Put_Line(Output_File, "");
               Put("Operation: "); Get(Operation); Skip_Line;
            when PopCommand =>
               The_Name:= Pop(Stacks, Top, Base, PopCommand'Pos(Operation)-9);
               If The_Name.Name /= "Underflow! " then
                  Print_Name(Output_File, The_Name); Put(Output_File, " Popped from stack ");
                  Put(Output_File, PushCommand'Pos(Operation)-9,2); Put_Line(Output_File, "");
               end if;
               Put("Operation: "); Get(Operation); Skip_Line;
            When Stop =>
               null;
         end case;
      end loop;
      Close(Output_File);
   end;

end MultiStack_B;
