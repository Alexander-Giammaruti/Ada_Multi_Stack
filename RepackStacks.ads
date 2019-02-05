-- in file RepackStacks.ads
With Ada.Text_IO; use Ada.Text_IO;

package RepackStacks is

   function floor(X: float) return Integer;

   type Names is record
      Name: String(1..11):= (Others => ' ');
      Length: Integer;
   end record;

   type MultiStack is array(Integer range <>) of Names;

   type Top_Base is array(Integer range <>) of Integer;

   function GetName return Names;

   procedure Print_Name(Output: File_Type; The_Name: Names);

   procedure Print_Stacks(Output: File_Type; Stack: MultiStack;
                          L0: Integer; M: Integer);

   procedure Print_Top_Base(Output: File_Type; Arr: Top_Base);

   procedure Print_OldTop(Output: File_Type; Arr: Top_Base);

   procedure MoveStack(Stacks: in out MultiStack; Top: in out Top_Base;
                       Base: in out Top_Base; NewBase: Top_Base);

   procedure Reallocate(Stacks: in out MultiStack; Top: in out Top_Base;
                        Base: in out Top_Base; OneArray: in out Top_Base;
                        K: Integer; X: Names);

   procedure Push(Output: File_Type; Stack: in out MultiStack;
                  Top: in out Top_Base; Base: in out Top_Base;
                  OldTop: in out Top_Base; K: Integer; X: Names);

   function Pop(Stack: in out MultiStack; Top: in out Top_Base;
                Base: in out Top_Base; K: Integer) return Names;

   procedure Initialize_Stacks(Stacks: in out MultiStack; Top: in out Top_Base;
                               Base: in out Top_Base; OneArray:  in out Top_Base;
                               L0: Integer; M: Integer; N: Integer);

end RepackStacks;
