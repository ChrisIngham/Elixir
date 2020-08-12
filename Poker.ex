# RANKED FROM HIGHEST TO LOWEST RANK

# Royal flush - is an ace high straight flush. EG A-K-Q-J-10 (all diamonds)

# Straight flush - 5 cards in order that are same suit

# Four of a kind - 4 of the same rank EG. 4 Jacks

# Full house - 3 cards of the same rank + 2 cards of the same rank. EG 2 2's and 3 Q's

# Flush - 5 cards all of the same suit

# Straight - 5 cards in order, suit does not matter

# Two pairs - 2 sets of 2 cards with same values EG. 2 8's and 2 J's

# Pair - 2 cards with same value

# High Card - Card with highest value

# TIE BREAKERS ARE DONE BY HIGHEST RANK OF EACH HAND!!!!!!!!!!!!!!!!!!



defmodule Card do

    def parse_int(n) when n >= 1 and n <= 52 do
        n = n - 1
        suit = n |> div(13) |> get_suit()
        face_value = rem(n, 13)
        {suit, face_value + 1}
    end

    defp get_suit(0), do: :clubs
    defp get_suit(1), do: :diamonds
    defp get_suit(2), do: :hearts
    defp get_suit(3), do: :spades

end


defmodule Poker do
    # Run the game, fetching a list of cards from stdin
    def deal(list) when is_list(list) do
        parse_cards(list)
    end

    # Take a list of ints and convert it to a list of cards
    def parse_cards(cards) when is_list(cards) do
        hands = Enum.map(cards, &Card.parse_int/1)
        player1 = [Enum.at(hands,0), Enum.at(hands,2),Enum.at(hands,4), Enum.at(hands,5), Enum.at(hands,6), Enum.at(hands,7), Enum.at(hands,8)]
		player2 = [Enum.at(hands,1), Enum.at(hands,3), Enum.at(hands,4), Enum.at(hands,5), Enum.at(hands,6), Enum.at(hands,7), Enum.at(hands,8)]

        rank_1 = check_rank(player1)
        rank_2 = check_rank(player2)
        # Needs 5 cards, so returns 5 "random" from the winners hand
        player1_5_card = [Enum.at(player1,0),Enum.at(player1,1),Enum.at(player1,4),Enum.at(player1,5),Enum.at(player1,6)]
        player2_5_card = [Enum.at(player2,0),Enum.at(player2,1),Enum.at(player2,4),Enum.at(player2,5),Enum.at(player2,6)]
        #returns cards
        player1_return = Enum.map(player1_5_card, fn {suit, rank} -> "#{rank}#{suit_to_string(suit)}" end) 
        player2_return = Enum.map(player2_5_card, fn {suit, rank} -> "#{rank}#{suit_to_string(suit)}" end)

        case compare_ranks(rank_1, rank_2) do
            :eq -> case high_card(player1, player2) do
                     :hand_1 -> player1_return
                     :hand_2 -> player2_return
                     _ -> "tie"
                   end
            :lt -> player2_return
            :gt -> player1_return
        end
    end


    def suit_to_string(:spades), do: "S"
    def suit_to_string(:hearts), do: "H"
    def suit_to_string(:clubs), do: "C"
    def suit_to_string(:diamonds), do: "D"
    
    def check_rank(hand) when is_list(hand) do
        cond do 
            royal_flush?(hand) -> {:royal_flush, 10}
            straight_flush?(hand) -> {:straight_flush, 9}
            four_of_a_kind?(hand) -> {:four_of_a_kind, 8}
            full_house?(hand) -> {:full_house, 7}
            flush?(hand) -> {:flush, 6}
            straight?(hand) -> {:straight, 5}
            two_pair?(hand) -> {:two_pair, 4}
            pair?(hand) -> {:pair, 3}
            true -> {:high_card, 1}
        end 
    end 
    
    # compare ranks and return `:eq` if they're the same, `:lt` if rank_1 wins, `:gt` if rank_2 wins
    def compare_ranks(rank_1, rank_2) do
        cond do 
            rank_1 > rank_2 ->
                :gt
            rank_1 < rank_2 ->
                :lt
            true ->
                :eq
        end
    end


        # ------------------------------Start of hand logic Functions -------------------------------------------


    #  ROYAL FLUSH
    def royal_flush?(hand) do
        if  (hand 
           |> Enum.group_by(fn {suit,_} -> suit end)
           |> Map.values()
           |> Enum.any?(fn cards -> length(cards) >= 5 end)) do

            straightRF = 
                hand 
                    |> Enum.map(fn {_,value} -> value end)
                    |> Enum.sort()
           
            if (Enum.member?(straightRF,1)) do
                cond do
                # 1 - 5 values of the 7 hand of cards
                    ( 
                    (Enum.at(straightRF,0) == ((Enum.at(straightRF,1)) - 1)) and
                    (Enum.at(straightRF,1) == ((Enum.at(straightRF,2)) - 1)) and
                    (Enum.at(straightRF,2) == ((Enum.at(straightRF,3)) - 1)) and
                    (Enum.at(straightRF,3) == ((Enum.at(straightRF,4)) - 1)) ) ->
                        true
                    # 2 - 6 values 
                    (
                    (Enum.at(straightRF,1) == ((Enum.at(straightRF,2)) - 1)) and
                    (Enum.at(straightRF,2) == ((Enum.at(straightRF,3)) - 1)) and
                    (Enum.at(straightRF,3) == ((Enum.at(straightRF,4)) - 1)) and
                    (Enum.at(straightRF,4) == ((Enum.at(straightRF,5)) - 1)) ) ->
                        true
                    
                    # 3 - 7 values doesnt make sense since both players would have straights.
                
                    # A _ _ 10 J Q K
                    (
                    (Enum.at(straightRF,3) == ((Enum.at(straightRF,4)) - 1)) and
                    (Enum.at(straightRF,4) == ((Enum.at(straightRF,5)) - 1)) and
                    (Enum.at(straightRF,5) == ((Enum.at(straightRF,6)) - 1)) and
                    (Enum.at(straightRF,6) == ((Enum.at(straightRF,0)) + 12)) ) ->
                        true

                    # A 2 _ _ J Q K
                    (
                    (Enum.at(straightRF,4) == ((Enum.at(straightRF,5)) - 1)) and
                    (Enum.at(straightRF,5) == ((Enum.at(straightRF,6)) - 1)) and
                    (Enum.at(straightRF,6) == ((Enum.at(straightRF,0)) + 12)) and
                    (Enum.at(straightRF,0) == ((Enum.at(straightRF,1)) - 1)) ) ->
                        true
                    
                    # A 2 3 _ _ Q K 
                    (
                    (Enum.at(straightRF,5) == ((Enum.at(straightRF,6)) - 1)) and
                    (Enum.at(straightRF,6) == ((Enum.at(straightRF,0)) + 12)) and
                    (Enum.at(straightRF,0) == ((Enum.at(straightRF,1)) - 1)) and
                    (Enum.at(straightRF,1) == ((Enum.at(straightRF,2)) - 1)) ) ->
                        true
                    
                    # A 2 3 4 _ _ K
                    (
                    (Enum.at(straightRF,6) == ((Enum.at(straightRF,0)) + 12)) and
                    (Enum.at(straightRF,0) == ((Enum.at(straightRF,1)) - 1)) and
                    (Enum.at(straightRF,1) == ((Enum.at(straightRF,2)) - 1)) and
                    (Enum.at(straightRF,2) == ((Enum.at(straightRF,3)) - 1)) ) ->
                        true
                    
                    # No Straight flush
                    true -> 
                        false
                end
            end    
        end
    end   

        # ----------------------------------------------------------------------------------------------

        
     # FLUSH STRAIGHT  
    def straight_flush?(hand) do    
        if (hand 
            |> Enum.group_by(fn {suit,_} -> suit end)
            |> Map.values()
            |> Enum.any?(fn cards -> length(cards) >= 5 end)) do
        # Function to find if straight has occured WORKS
            straightF = 
                hand 
                    |> Enum.map(fn {_,value} -> value end)
                    |> Enum.sort()
                    
            cond do
                # 1 - 5 values of the 7 hand of cards
                ((Enum.at(straightF,0) == ((Enum.at(straightF,1)) - 1)) and
                (Enum.at(straightF,1) == ((Enum.at(straightF,2)) - 1)) and
                (Enum.at(straightF,2) == ((Enum.at(straightF,3)) - 1)) and
                (Enum.at(straightF,3) == ((Enum.at(straightF,4)) - 1)) ) ->
                    true
                # 2 - 6 values 
                ((Enum.at(straightF,1) == ((Enum.at(straightF,2)) - 1)) and
                (Enum.at(straightF,2) == ((Enum.at(straightF,3)) - 1)) and
                (Enum.at(straightF,3) == ((Enum.at(straightF,4)) - 1)) and
                (Enum.at(straightF,4) == ((Enum.at(straightF,5)) - 1)) ) ->
                    true
                
                # 3 - 7 values doesnt make sense since both players would have straights.
            
                # A _ _ 10 J Q K
                ((Enum.at(straightF,3) == ((Enum.at(straightF,4)) - 1)) and
                (Enum.at(straightF,4) == ((Enum.at(straightF,5)) - 1)) and
                (Enum.at(straightF,5) == ((Enum.at(straightF,6)) - 1)) and
                (Enum.at(straightF,6) == ((Enum.at(straightF,0)) + 12)) ) ->
                    true

                # A 2 _ _ J Q K
                ((Enum.at(straightF,4) == ((Enum.at(straightF,5)) - 1)) and
                (Enum.at(straightF,5) == ((Enum.at(straightF,6)) - 1)) and
                (Enum.at(straightF,6) == ((Enum.at(straightF,0)) + 12)) and
                (Enum.at(straightF,0) == ((Enum.at(straightF,1)) - 1)) ) ->
                    true
                
                # A 2 3 _ _ Q K 
                ((Enum.at(straightF,5) == ((Enum.at(straightF,6)) - 1)) and
                (Enum.at(straightF,6) == ((Enum.at(straightF,0)) + 12)) and
                (Enum.at(straightF,0) == ((Enum.at(straightF,1)) - 1)) and
                (Enum.at(straightF,1) == ((Enum.at(straightF,2)) - 1)) ) ->
                    true
                
                # A 2 3 4 _ _ K
                ((Enum.at(straightF,6) == ((Enum.at(straightF,0)) + 12)) and
                (Enum.at(straightF,0) == ((Enum.at(straightF,1)) - 1)) and
                (Enum.at(straightF,1) == ((Enum.at(straightF,2)) - 1)) and
                (Enum.at(straightF,2) == ((Enum.at(straightF,3)) - 1)) ) ->
                    true
                
                # No Straight flush
                true -> 
                    false
            end
            
        end
    end           


        # ------------------------------------------------------------------------------------

        
     # Four of a kind
    def four_of_a_kind?(hand) do
        p1Four = 
            hand
                |> Enum.map(fn {_,value} -> value end)
                |> Enum.sort()
        cond do
            # (x x x x _ _ _)
            ( (Enum.at(p1Four, 0) == Enum.at(p1Four, 1)) and 
              (Enum.at(p1Four, 0) == Enum.at(p1Four, 2)) and
              (Enum.at(p1Four, 0) == Enum.at(p1Four, 3)) and 
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 4)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 5)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 6)) and
              (Enum.at(p1Four, 4) != Enum.at(p1Four, 5)) and
              (Enum.at(p1Four, 4) != Enum.at(p1Four, 6)) and
              (Enum.at(p1Four, 5) != Enum.at(p1Four, 6)) ) ->
                true
            # (_ x x x x _ _)
            ( (Enum.at(p1Four, 1) == Enum.at(p1Four, 2)) and 
              (Enum.at(p1Four, 1) == Enum.at(p1Four, 3)) and
              (Enum.at(p1Four, 1) == Enum.at(p1Four, 4)) and 
              (Enum.at(p1Four, 1) != Enum.at(p1Four, 0)) and
              (Enum.at(p1Four, 1) != Enum.at(p1Four, 5)) and
              (Enum.at(p1Four, 1) != Enum.at(p1Four, 6)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 5)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 6)) and
              (Enum.at(p1Four, 5) != Enum.at(p1Four, 6)) ) ->
                true 
            # (_ _ x x x x _)
            ( (Enum.at(p1Four, 2) == Enum.at(p1Four, 3)) and 
              (Enum.at(p1Four, 2) == Enum.at(p1Four, 4)) and
              (Enum.at(p1Four, 2) == Enum.at(p1Four, 5)) and 
              (Enum.at(p1Four, 2) != Enum.at(p1Four, 0)) and
              (Enum.at(p1Four, 2) != Enum.at(p1Four, 1)) and
              (Enum.at(p1Four, 2) != Enum.at(p1Four, 6)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 1)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 6)) and
              (Enum.at(p1Four, 1) != Enum.at(p1Four, 6)) ) ->
                true 
            # (_ _ _ x x x x)
            ( (Enum.at(p1Four, 3) == Enum.at(p1Four, 4)) and 
              (Enum.at(p1Four, 3) == Enum.at(p1Four, 5)) and
              (Enum.at(p1Four, 3) == Enum.at(p1Four, 6)) and 
              (Enum.at(p1Four, 3) != Enum.at(p1Four, 0)) and
              (Enum.at(p1Four, 3) != Enum.at(p1Four, 1)) and
              (Enum.at(p1Four, 3) != Enum.at(p1Four, 2)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 1)) and
              (Enum.at(p1Four, 0) != Enum.at(p1Four, 2)) and
              (Enum.at(p1Four, 1) != Enum.at(p1Four, 2)) ) ->
                true  
            true ->
                false
        end
    end    
        
        # ------------------------------------------------------------------------------------
        
        
        #Full HOUSE
    def full_house?(hand) do
        p1Full = 
            hand 
                |> Enum.map(fn {_,value} -> value end)
                |> Enum.sort()
        cond do 
            # (x x x y y _ _ )          
            ( (Enum.at(p1Full, 0) == Enum.at(p1Full, 1)) and
              (Enum.at(p1Full, 0) == Enum.at(p1Full, 2)) and 
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 3)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 5)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 6)) and 
              (Enum.at(p1Full, 3) == Enum.at(p1Full, 4)) and
              (Enum.at(p1Full, 5) != Enum.at(p1Full, 6)) ) -> 
                true
            # (x x x _ y y _)
            ( (Enum.at(p1Full, 0) == Enum.at(p1Full, 1)) and
              (Enum.at(p1Full, 0) == Enum.at(p1Full, 2)) and 
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 3)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 4)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 6)) and 
              (Enum.at(p1Full, 4) == Enum.at(p1Full, 5)) and
              (Enum.at(p1Full, 3) != Enum.at(p1Full, 6)) ) -> 
                true
            # (x x x _ _ y y )
            ( (Enum.at(p1Full, 0) == Enum.at(p1Full, 1)) and
              (Enum.at(p1Full, 0) == Enum.at(p1Full, 2)) and 
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 3)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 4)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 5)) and 
              (Enum.at(p1Full, 5) == Enum.at(p1Full, 6)) and
              (Enum.at(p1Full, 3) != Enum.at(p1Full, 4)) ) -> 
                true
            # ( _ x x x _ y y )
            ( (Enum.at(p1Full, 1) == Enum.at(p1Full, 2)) and
              (Enum.at(p1Full, 1) == Enum.at(p1Full, 3)) and 
              (Enum.at(p1Full, 1) != Enum.at(p1Full, 0)) and
              (Enum.at(p1Full, 1) != Enum.at(p1Full, 4)) and
              (Enum.at(p1Full, 1) != Enum.at(p1Full, 5)) and 
              (Enum.at(p1Full, 5) == Enum.at(p1Full, 6)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 4)) ) -> 
                true
            # ( _ _ x x x y y )
            ( (Enum.at(p1Full, 2) == Enum.at(p1Full, 3)) and
              (Enum.at(p1Full, 2) == Enum.at(p1Full, 4)) and 
              (Enum.at(p1Full, 2) != Enum.at(p1Full, 0)) and
              (Enum.at(p1Full, 2) != Enum.at(p1Full, 1)) and
              (Enum.at(p1Full, 2) != Enum.at(p1Full, 5)) and 
              (Enum.at(p1Full, 5) == Enum.at(p1Full, 6)) and
              (Enum.at(p1Full, 0) != Enum.at(p1Full, 1)) ) -> 
                true
            true ->
                false
        end
    end

        # -------------------------------------------------------------------------------------
        

    # Function to find if flush has occured WORKS
    
    def flush?(hand) do
        hand 
           |> Enum.group_by(fn {suit,_} -> suit end)
           |> Map.values()
           |> Enum.any?(fn cards -> length(cards) >= 5 end)
    
    end
    
    
     #------------------------------------------------------------------------------


        # # Function to find if straight has occured WORKS
    def straight?(hand) do    
        straight = 
            hand 
                |> Enum.map(fn {_,value} -> value end)
                |> Enum.sort()
        cond do
            # 1 - 5 values of the 7 hand of cards
            ((Enum.at(straight,0) == ((Enum.at(straight,1)) - 1)) and
             (Enum.at(straight,1) == ((Enum.at(straight,2)) - 1)) and
             (Enum.at(straight,2) == ((Enum.at(straight,3)) - 1)) and
             (Enum.at(straight,3) == ((Enum.at(straight,4)) - 1)) ) ->
                true
            # 2 - 6 values 
            ((Enum.at(straight,1) == ((Enum.at(straight,2)) - 1)) and
             (Enum.at(straight,2) == ((Enum.at(straight,3)) - 1)) and
             (Enum.at(straight,3) == ((Enum.at(straight,4)) - 1)) and
             (Enum.at(straight,4) == ((Enum.at(straight,5)) - 1)) ) ->
                true
            
            # 3 - 7 values doesnt make sense since both players would have straights.
           
            # A _ _ 10 J Q K
            ((Enum.at(straight,3) == ((Enum.at(straight,4)) - 1)) and
             (Enum.at(straight,4) == ((Enum.at(straight,5)) - 1)) and
             (Enum.at(straight,5) == ((Enum.at(straight,6)) - 1)) and
             (Enum.at(straight,6) == ((Enum.at(straight,0)) + 12)) ) ->
                true

            # A 2 _ _ J Q K
            ((Enum.at(straight,4) == ((Enum.at(straight,5)) - 1)) and
             (Enum.at(straight,5) == ((Enum.at(straight,6)) - 1)) and
             (Enum.at(straight,6) == ((Enum.at(straight,0)) + 12)) and
             (Enum.at(straight,0) == ((Enum.at(straight,1)) - 1)) ) ->
                true
            
            # A 2 3 _ _ Q K 
            ((Enum.at(straight,5) == ((Enum.at(straight,6)) - 1)) and
             (Enum.at(straight,6) == ((Enum.at(straight,0)) + 12)) and
             (Enum.at(straight,0) == ((Enum.at(straight,1)) - 1)) and
             (Enum.at(straight,1) == ((Enum.at(straight,2)) - 1)) ) ->
                true
            
            # A 2 3 4 _ _ K
            ((Enum.at(straight,6) == ((Enum.at(straight,0)) + 12)) and
             (Enum.at(straight,0) == ((Enum.at(straight,1)) - 1)) and
             (Enum.at(straight,1) == ((Enum.at(straight,2)) - 1)) and
             (Enum.at(straight,2) == ((Enum.at(straight,3)) - 1)) ) ->
                true
            
            # No Straight
            true -> 
                false
        end
    end

        #-------------------------------------------------------------------------------------------


        # #   Two Pair
    def two_pair?(hand) do
        p1Values = 
            hand 
                |> Enum.map(fn {_,value} -> value end)
                |> Enum.sort()
        cond do 
            # checks to see if (x x y y _ _ _)
            ( (Enum.at(p1Values, 0) == Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 2)) and 
              (Enum.at(p1Values, 2) == Enum.at(p1Values, 3)) and
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 2)) and  
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 5)) and
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 6)) and 
              (Enum.at(p1Values, 5) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 5) != Enum.at(p1Values, 2)) and  
              (Enum.at(p1Values, 5) != Enum.at(p1Values, 6)) and 
              (Enum.at(p1Values, 6) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 6) != Enum.at(p1Values, 2)) ) ->
                true
            # checks to see if (x x _ y y _ _ )
            ( (Enum.at(p1Values, 0) == Enum.at(p1Values, 1)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 3)) and  
              (Enum.at(p1Values, 3) == Enum.at(p1Values, 4)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 3)) and  
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 5)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 6)) and 
              (Enum.at(p1Values, 5) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 5) != Enum.at(p1Values, 3)) and  
              (Enum.at(p1Values, 5) != Enum.at(p1Values, 6)) and 
              (Enum.at(p1Values, 6) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 6) != Enum.at(p1Values, 3)) ) ->
                true
            # checks to see if (x x _ _ y y _ )
            ( (Enum.at(p1Values, 0) == Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 4)) and 
              (Enum.at(p1Values, 4) == Enum.at(p1Values, 5)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 3)) and  
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 4)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 6)) and 
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 4)) and  
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 6)) and 
              (Enum.at(p1Values, 6) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 6) != Enum.at(p1Values, 4)) ) ->
                true
            # checks to see if (x x _ _ _ y y )
            ( (Enum.at(p1Values, 0) == Enum.at(p1Values, 1)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 5)) and  
              (Enum.at(p1Values, 5) == Enum.at(p1Values, 6)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 5)) and  
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 4)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 4)) and  
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 0)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 5)) ) ->
                true
            # checks to see if (_ x x _ _ y y )
            ( (Enum.at(p1Values, 1) == Enum.at(p1Values, 2)) and
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 5)) and  
              (Enum.at(p1Values, 5) == Enum.at(p1Values, 6)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 3)) and  
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 4)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 4)) and  
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 5)) ) ->
                true
            
            # checks to see if (_ _ x x _ y y )
            ( (Enum.at(p1Values, 2) == Enum.at(p1Values, 3)) and
              (Enum.at(p1Values, 2) != Enum.at(p1Values, 5)) and  
              (Enum.at(p1Values, 5) == Enum.at(p1Values, 6)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 2)) and  
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 4)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 2)) and 
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 4)) and  
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 2)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 5)) ) ->
                true
            # checks to see if (_ _ _ x x y y)
            ( (Enum.at(p1Values, 3) == Enum.at(p1Values, 4)) and
              (Enum.at(p1Values, 3) != Enum.at(p1Values, 5)) and  
              (Enum.at(p1Values, 5) == Enum.at(p1Values, 6)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 1)) and 
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 2)) and  
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 3)) and
              (Enum.at(p1Values, 0) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 2)) and 
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 3)) and  
              (Enum.at(p1Values, 1) != Enum.at(p1Values, 5)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 3)) and 
              (Enum.at(p1Values, 4) != Enum.at(p1Values, 5)) ) ->
                true
            true ->
                false
        end
    end


        #-----------------------------------------------------------------------------------------------


        # Function to find if pair has occured WORKS
    def pair?(hand) do
        cond do
            ( (Enum.at(hand, 0) == Enum.at(hand, 1)) or 
              (Enum.at(hand, 0) == Enum.at(hand, 2)) or 
              (Enum.at(hand, 0) == Enum.at(hand, 3)) or 
              (Enum.at(hand, 0) == Enum.at(hand, 4)) or
              (Enum.at(hand, 0) == Enum.at(hand, 5)) or 
              (Enum.at(hand, 0) == Enum.at(hand, 6)) or
              (Enum.at(hand, 0) == Enum.at(hand, 7)) ) -> 
                true
            ( (Enum.at(hand, 1) == Enum.at(hand, 2)) or 
              (Enum.at(hand, 1) == Enum.at(hand, 3)) or 
              (Enum.at(hand, 1) == Enum.at(hand, 4)) or
              (Enum.at(hand, 1) == Enum.at(hand, 5)) or 
              (Enum.at(hand, 1) == Enum.at(hand, 6)) or
              (Enum.at(hand, 1) == Enum.at(hand, 7)) ) -> 
                true
            ( (Enum.at(hand, 2) == Enum.at(hand, 3)) or 
              (Enum.at(hand, 2) == Enum.at(hand, 4)) or
              (Enum.at(hand, 2) == Enum.at(hand, 5)) or 
              (Enum.at(hand, 2) == Enum.at(hand, 6)) or
              (Enum.at(hand, 2) == Enum.at(hand, 7)) ) -> 
                true
            ( (Enum.at(hand, 3) == Enum.at(hand, 4)) or
              (Enum.at(hand, 3) == Enum.at(hand, 5)) or 
              (Enum.at(hand, 3) == Enum.at(hand, 6)) or
              (Enum.at(hand, 3) == Enum.at(hand, 7)) ) -> 
                true
            ( (Enum.at(hand, 4) == Enum.at(hand, 5)) or 
              (Enum.at(hand, 4) == Enum.at(hand, 6)) or
              (Enum.at(hand, 4) == Enum.at(hand, 7)) ) -> 
                true
            ( (Enum.at(hand, 5) == Enum.at(hand, 6)) or
              (Enum.at(hand, 4) == Enum.at(hand, 7)) ) -> 
                true
            ( (Enum.at(hand, 6) == Enum.at(hand, 7)) ) -> 
                true
            true ->
                false
        end
    end
       
       # -------------------------------------------------------------------------------------------------
       
       
        # Function to see highest card, still need to do this individual and then compare. WORKS
    # def high_card(hand) do
    #     hand |> Enum.map(fn {_, value} -> value end) |> Enum.max()
    # end
    def high_card(hand_1, hand_2) do
        hand_1 = Enum.sort_by(hand_1, fn {_suit, value} -> value end, &>=/2)
        hand_2 = Enum.sort_by(hand_2, fn {_suit, value} -> value end, &>=/2)
        get_high_card(hand_1, hand_2)
    end
    
    defp get_high_card([], []), do: :tie
    defp get_high_card([{_, card_1} | _], [{_, card_2} | _]) when card_1 > card_2, do: :hand_1
    defp get_high_card([{_, card_1} | _], [{_, card_2} | _]) when card_1 < card_2, do: :hand_2
    defp get_high_card([_ | hand_1], [_ | hand_2]), do: get_high_card(hand_1, hand_2)
        

end
 