int[] goal = {2, 7, 0, 0, 0};  //Global goal
ArrayList<int[]> subgoals = new ArrayList<int[]>();
IntList _found = new IntList();

InferenceEngine IE;
RuleBase RB;
WorkingMemory WM;

void setup() {
  
  IE = new InferenceEngine();
  RB = new RuleBase();
  WM = new WorkingMemory();
  
  subgoals.add(goal);
  _found.append(0);
  IE.recursiveInference();
  
}

class InferenceEngine {

  //Performs match, select, and act on 
  boolean recursiveInference() {

    //Perform match, select, and act on each goal added to the subgoals list.
    for (int i = 0; i < subgoals.size(); i++) {

      if (_found.get(i) == 0) {
        println();

        //Current step
        println("Step: " + (i+1));

        //Current subgoal 
        int[] _sg = subgoals.get(i);
        print("Goal hypothesis: ");
        for (int j = 0; j < 5; j++) {
          print(_sg[j] + ", ");
        }
        println();
        
        //If subgoal is in working memory, return true to function       
        if (matchWM(subgoals.get(i), i)) {

          int[] sg = subgoals.get(i);
          for (int j = 0; j < 5; j++) {

            print(sg[j] + ", ");
          }
          println("In WM");
          _found.set(i, 1);
        }//If subgoal is not in working memory, perform match, select, and act on subgoal.
        else {

          int[] sg = subgoals.get(i);
          for (int j = 0; j < 5; j++) {

            print(sg[j] + ", ");  //Printing not in working memory.
          }
          println("Not in WM");

          //Match, select, and act
          matchSelectAct(subgoals.get(i), i);
        }

        return false;
      }
    }

    return true ;
  }

  //Match subgoal to WM 
  boolean matchWM(int[] subgoal, int index) {
    
    boolean found = false; //Will change to true if the subgoal matches a fact in the working memory.

    for (int i = 0; i < WM.WM.size(); i++) {

      int check = 0;
      int[] _WM = WM.WM.get(i);

      for (int j = 0; j < 5; j++) { //Checking whether each index of the subgoal matches each index of the fact.

        if (subgoal[j] == _WM[j]) {
          check++;
          
          if (check == 5) { //If equal, function will return true.
            _found.set(index, 1);
            found = true;
            break;
          }
        }
      }
    }

    if (found) {
      return true;
    } else {
      return false;
    }
  }


  //Match subgoal to rules consequent.
  //Select antecedents to promote as subgoals.
  //Act on subgoals to add to working memory and fire rules.
  boolean matchSelectAct(int[] goal, int index) {
    
    //MATCHING RULES WHOSE CONSEQUENT MATCHES THE SUBGOAL
    for (int i = 0; i < RB.consequents.size(); i++) {

      int[] con = RB.consequents.get(i);
      int check = 0;

      for (int j = 0; j < 5; j++) {

        //Checking each index of goal matches consequent of rule
        if (goal[j] == con[j]) {

          check++;

          //If goal matches consequent:
          if (check == 5) {
            _found.set(index, 1);
            
            //Select current rule in which goal matches the consequent of.
            println("Using R" + (i+1) + ": the new subgoal hypotheses that have to be proven are");



            //SELECTING ANTECEDENTS OF RULE TO BECOME SUBGOALS
            //Printing out antecedents of the rule chosen
            for (int k = 0; k <5; k++) {

              int[] sg = subset(RB.antecedents.get(i), (k*5), 5);
              if (sg[0] != 0) {

                for (int l = 0; l < 5; l++) {

                  print(sg[l] + ", ");
                }
                println();
              }
            }

            //Adding chosen antecedents to subgoals
            for (int k = 0; k <5; k++) {

              int[] sg = subset(RB.antecedents.get(i), (k*5), 5);

              //Add to sub goals if not completely 0
              if (sg[0] != 0) {
                println();

                subgoals.add(sg);
                _found.append(0);
             
              }
              
              //ACTING ON SUBGOALS BY ADDING TO WORKING MEMORY AND FIRING RULES.
              if (recursiveInference()) {

                int[] co = RB.consequents.get(i);

                //Adding to working memory
                print("Added to working memory");
                print("--> (");
                for (int l = 0; l < 5; l++) {

                  print(co[l] + ", ");
                }
                print(")");
                println();

                //Firing rule
                print("R" + (i+1) + " PROVED");
                print("--> (");
                for (int l = 0; l < 5; l++) {

                  print(co[l] + ", ");
                }
                print(")");
                println();

                return true;
              }
            }
          }
        }
      }
    }

   return true;
  }
}


class RuleBase {
  
  ArrayList<int[]> antecedents = new ArrayList<int[]>();
  ArrayList<int[]> consequents = new ArrayList<int[]>();
  
  RuleBase() {
    
    antecedents.add(new int[] {6, 8, 0, 0, 0,    1, 3, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //fh && ac
    antecedents.add(new int[] {14, 19, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //ns
    antecedents.add(new int[] {18, 20, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //rt
    antecedents.add(new int[] {4, 10, 0, 0, 0,   5, 13, 0, 0, 0,   11, 9, 0, 0, 0,   0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //dj && em && ki
    antecedents.add(new int[] {16, 17, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //pq
    antecedents.add(new int[] {21, 22, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //uv
    
    consequents.add(new int[] {2, 7, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //bg
    consequents.add(new int[] {5, 13, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});   //em
    consequents.add(new int[] {16, 17, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //pq
    consequents.add(new int[] {1, 3, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});    //ac
    consequents.add(new int[] {14, 19, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0});  //ns
    consequents.add(new int[] {11, 9, 0, 0, 0,  0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0,    0, 0, 0, 0, 0}); //ki
    
  }
}


class WorkingMemory {
  
  ArrayList<int[]> WM = new ArrayList<int[]>();

  WorkingMemory() {
    
    int[] fh = {6, 8, 0, 0, 0};
    WM.add(fh); //fh
    
    int[] dj = {4, 10, 0, 0, 0};
    WM.add(dj);
    
    int[] uv = {21, 22, 0, 0, 0};
    WM.add(uv);
    
    int[] rt = {18, 20, 0, 0, 0};
    WM.add(rt);
    
  }
}