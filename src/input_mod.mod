  �  8   k820309              18.0        �}�Z                                                                                                          
       Input_mod.f90 INPUT_MOD                                                     
                                                              u #INPUT_ADDRESS_SUB    #INPUT_BASIC_SUB    #INPUT_ARRAY_SUB    #INPUT_ANALYSIS_SUB                      @               @                '�             	      #MODELNAME    #INPUTDIR    #ANALYSISDIR 	   #OUTPUTDIR 
   #ANALYSISOUTPUTDIR    #ANALYSESNAMES    #ANALYSISTYPE    #NUMBEROFANALYSES    #VERSION                 �                                                                      �                                   �                                  �                              	     �       �                           �                              
     �       J                          �                                   �       �             .           �                                          x      �                      &                                                                �                                   �                         �                                   �                         �                                   �      	   	                     @                                '8                    #NOREACHES    #TOTALTIME    #TIMESTEP    #Q_UP    #H_DW    #CNTRLV    #CNTRLV_RATIO                 �                                                              �                                             
                �                                             
                �                                             
                �                                              
                �                                   (          
                �                                   0          
                     @               @                '�                   #REACHDISC    #REACHLENGTH    #REACHTYPE    #REACHSLOPE    #REACHMANNING    #REACHWIDTH               �                                                                        &                                                      �                                          H                 
            &                                                      �                                          �                 
            &                                                      �                                          �                 
            &                                                      �                                                           
            &                                                      �                                          h                
            &                                                                                                                                                                                                                                                                                                  !                                       X              600                                            "                                       �              500                                            #     N                            O       �              C('ERROR IN ALLOCATING Arrays. ERROR NUMBER IS :', I4, '   LOCATION: ??????.')                                                             $     '                            (       �              C('OOPS!!!  FAIL TO OPERATE PROPERLY.')                                                             %                                        �              C('PRESS ENTER TO End ...')                                                             &     P                            Q       �              C( 'ERROR IN OPEN STATEMENT. Unit NUMBER=', I3, '   ERROR NUMBER IS=', I4  )                                                                 '     Q                            R       �              C( 'ERROR IN Close STATEMENT. Unit NUMBER=', I3, '   ERROR NUMBER IS=', I4  )                                                                 (                                       �              501                                            )     F                            G       �              C('ERROR IN READ STATEMENT. Unit IS : ',I5,' ERROR NUMBER IS : ', I5 )                                                             *     L                            M       �              C('End OF FILE IN READ STATEMENT. Unit IS : ',I5,' ERROR NUMBER IS : ', I5 )                                                             +     N                            O       �              C('End OF RECORD IN READ STATEMENT. Unit IS : ',I5,' ERROR NUMBER IS : ', I5 )                                                             ,     G                            H       �              C('ERROR IN write STATEMENT. Unit IS : ',I5,' ERROR NUMBER IS : ', I5 )                                                             -                                       �              502                                            .                                       �              510#         @      X                                                 #MODELINFO /             D                                 /     �              #INPUT_DATA_TP    #         @      X                                                 #MODELINFO 0   #INITIALINFO 1             
                                  0     �             #INPUT_DATA_TP              D P                                1     8               #INITIALDATA_TP    #         @      X                                                 #MODELINFO 2   #INITIALINFO 3   #GEOMETRY 4             
                                  2     �             #INPUT_DATA_TP              
                                  3     8              #INITIALDATA_TP              
D P                                4     �              #GEOMETRY_TP    #         @      X                                                 #I_ANALYSIS 5   #MODELINFO 6             
                                 5                     
D                                 6     �              #INPUT_DATA_TP       �          fn#fn    �   @   J   PARAMETERS_MOD       �       gen@INPUT -   �  �       INPUT_DATA_TP+PARAMETERS_MOD 7   �  P   a   INPUT_DATA_TP%MODELNAME+PARAMETERS_MOD 6   �  P   a   INPUT_DATA_TP%INPUTDIR+PARAMETERS_MOD 9   %  P   a   INPUT_DATA_TP%ANALYSISDIR+PARAMETERS_MOD 7   u  P   a   INPUT_DATA_TP%OUTPUTDIR+PARAMETERS_MOD ?   �  P   a   INPUT_DATA_TP%ANALYSISOUTPUTDIR+PARAMETERS_MOD ;     �   a   INPUT_DATA_TP%ANALYSESNAMES+PARAMETERS_MOD :   �  H   a   INPUT_DATA_TP%ANALYSISTYPE+PARAMETERS_MOD >   �  H   a   INPUT_DATA_TP%NUMBEROFANALYSES+PARAMETERS_MOD 5   A  H   a   INPUT_DATA_TP%VERSION+PARAMETERS_MOD .   �  �       INITIALDATA_TP+PARAMETERS_MOD 8   7  H   a   INITIALDATA_TP%NOREACHES+PARAMETERS_MOD 8     H   a   INITIALDATA_TP%TOTALTIME+PARAMETERS_MOD 7   �  H   a   INITIALDATA_TP%TIMESTEP+PARAMETERS_MOD 3     H   a   INITIALDATA_TP%Q_UP+PARAMETERS_MOD 3   W  H   a   INITIALDATA_TP%H_DW+PARAMETERS_MOD 5   �  H   a   INITIALDATA_TP%CNTRLV+PARAMETERS_MOD ;   �  H   a   INITIALDATA_TP%CNTRLV_RATIO+PARAMETERS_MOD +   /  �       GEOMETRY_TP+PARAMETERS_MOD 5   �  �   a   GEOMETRY_TP%REACHDISC+PARAMETERS_MOD 7   t	  �   a   GEOMETRY_TP%REACHLENGTH+PARAMETERS_MOD 5   
  �   a   GEOMETRY_TP%REACHTYPE+PARAMETERS_MOD 6   �
  �   a   GEOMETRY_TP%REACHSLOPE+PARAMETERS_MOD 8   0  �   a   GEOMETRY_TP%REACHMANNING+PARAMETERS_MOD 6   �  �   a   GEOMETRY_TP%REACHWIDTH+PARAMETERS_MOD $   X  p       SMLL+PARAMETERS_MOD $   �  p       SHRT+PARAMETERS_MOD (   8  s       FILEINFO+PARAMETERS_MOD '   �  s       FILEADR+PARAMETERS_MOD )     �       FMT_ALLCT+PARAMETERS_MOD &   �  �       FMT_FL+PARAMETERS_MOD '   �  �       FMT_END+PARAMETERS_MOD -   1  �       FMT_ERR1_OPEN+PARAMETERS_MOD .     �       FMT_ERR1_CLOSE+PARAMETERS_MOD -   �  s       FILEDATAMODEL+PARAMETERS_MOD )   G  �       FMT_READ1+PARAMETERS_MOD )     �       FMT_READ2+PARAMETERS_MOD )   �  �       FMT_READ3+PARAMETERS_MOD *   �  �       FMT_WRITE1+PARAMETERS_MOD +   r  s       FILEDATAGEO+PARAMETERS_MOD )   �  s       UNINPTANA+PARAMETERS_MOD "   X  W       INPUT_ADDRESS_SUB ,   �  [   a   INPUT_ADDRESS_SUB%MODELINFO     
  h       INPUT_BASIC_SUB *   r  [   a   INPUT_BASIC_SUB%MODELINFO ,   �  \   a   INPUT_BASIC_SUB%INITIALINFO     )  v       INPUT_ARRAY_SUB *   �  [   a   INPUT_ARRAY_SUB%MODELINFO ,   �  \   a   INPUT_ARRAY_SUB%INITIALINFO )   V  Y   a   INPUT_ARRAY_SUB%GEOMETRY #   �  g       INPUT_ANALYSIS_SUB .     @   a   INPUT_ANALYSIS_SUB%I_ANALYSIS -   V  [   a   INPUT_ANALYSIS_SUB%MODELINFO 