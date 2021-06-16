//
//  MusicScale.swift
//  XvUtils
//
//  Created by Jason Snell on 6/16/21.
//  Copyright © 2021 Jason J. Snell. All rights reserved.
//

import Foundation

public class MusicScale {
    
    //MARK: - CONSTANTS
    internal let NOTES_PER_OCTAVE:Int = 7
    internal let KEYS_PER_OCTAVE:Int = 12
    internal let DEFAULT_OCTAVE:Int = 3
    internal let LOWEST_OCTAVE:Int = -2
    internal let HIGHEST_OCTAVE:Int = 8
    internal let OCTAVE_TOTAL:Int = 11
    internal let MIDDLE_C:Int = 60
    internal let KEYS_TOTAL:Int = 128
    
    //middle C is 0
    
    //All                                         C   C#  D   D#  E   F   F#  G   G#  A   A#  B
    //                                            0   1   2   3   4   5   6   7   8   9   10  11
    
    //Major                                       C   D   E   F   G   A   B
    fileprivate let majorScale:[Int] =           [0,  2,  4,  5,  7,  9,  11]
    
    //Minor                                       C   D   D#  F   G   G#  A#
    fileprivate let minorScale:[Int] =           [0,  2,  3,  5,  7,  8,  10]

    //Dorian                                      C   D   D#  F   G   A   A#
    fileprivate let dorianScale:[Int] =          [0,  2,  3,  5,  7,  9,  10]
    
    //Phrygian                                    C  C#   D#  F   G   G#  A#
    fileprivate let phrygianScale:[Int] =        [0,  1,  3,  5,  7,  8,  10]
    
    //Lydian                                      C   D   E   F#  G   A   B
    fileprivate let lydianScale:[Int] =          [0,  2,  4,  6,  7,  9,  11]
    
    //Mixolydian                                  C   D   E   F   G,  A   A#
    fileprivate let mixolydianScale:[Int] =      [0,  2,  4,  5,  7,  9,  10]
    
    //Aeolian                                     C   D   D#  F   G   G#  A#
    fileprivate let aeolianScale:[Int] =         [0,  2,  3,  5,  7,  8,  10]
    
    //Locrian                                     C   C#  D#  F   F   G#  A#
    fileprivate let locrianScale:[Int] =         [0,  1,  3,  5,  6,  8,  10]
    
    //Minor Blues                                 C   D#  F   F#  F#  G   A#
    fileprivate let minorBluesScale:[Int] =      [0,  3,  5,  6,  6,  7,  10]
    
    //Major Blues                                 C   D   D#  E   E   G   A
    fileprivate let majorBluesScale:[Int] =      [0,  2,  3,  4,  4,  7,  9]
    
    //Minor Pentatonic                            C   D#  F   G   F   G   A#
    fileprivate let minorPentatonicScale:[Int] = [0,  3,  5,  7,  5,  7,  10]
    
    //Major Pentatonic                            C   D   E   G   E   G   A
    fileprivate let majorPentatonicScale:[Int] = [0,  2,  4,  7,  4,  7,  9]
    
    //Diminished                                  C   D   D#  F   G#  A   B
    fileprivate let diminishedScale:[Int] =      [0,  2,  3,  5,  8,  9,  11]
    
    //Chromatic                                   C  C#   D   D#  A   A#  B
    fileprivate let chromaticScale:[Int] =       [0,  1,  2,  3,  9,  10, 11]
    
    //Harmonic Minor                              C   D   D#  F   G   G#  B
    fileprivate let harmonicMinorScale:[Int] =   [0,  2,  3,  5,  7,  8,  11]
    
    //Whole Tone                                  C   D   E   F#  G#  A#
    fileprivate let wholeToneScale:[Int] =       [0,  2,  4,  6,  8,  10]
    
    public static let MAJOR:String = "Major"
    public static let MINOR:String = "Minor"
    public static let DORIAN:String = "Dorian"
    public static let PHRYGIAN:String = "Phrygian"
    public static let LYDIAN:String = "Lydian"
    public static let MIXOLYDIAN:String = "Mixolydian"
    public static let AEOLIAN:String = "Aeolian"
    public static let LOCARIAN:String = "Locarian"
    public static let MAJOR_BLUES:String = "MajorNlues"
    public static let MINOR_BLUES:String = "MinorNlues"
    public static let MAJOR_PENTATONIC:String = "MajorPentatonic"
    public static let MINOR_PENTATONIC:String = "MinorPentatonic"
    public static let DIMINISHED:String = "Diminished"
    public static let CHROMATIC:String = "Chromatic"
    public static let HARMONIC_MINOR:String = "HarmonicMinor"
    public static let WHOLE_TONE:String = "WholeTone"
    
    fileprivate var _currScale:[Int] = []
    fileprivate var _allNotesInScale:[Int] = []
    
    //MARK: - ROOT KEY
    fileprivate var _rootKey:Int = 0
    internal var rootKey:Int {
        get { return _rootKey }
        set { _rootKey = newValue }
    }
    
    fileprivate let debug:Bool = false
    
    public init(scale:String = MusicScale.MAJOR) {
        
        //set scale
        _setMusicalScale(withScaleID: scale)
        
        //set notes for all octaves
        _allNotesInScale = _getScaleNotes(
            fromOctaveArray: _getArrayOfOctaves(withCenter: 0, withRange: OCTAVE_TOTAL)
        )
        
    }
    
    public func getInScaleMidiNote(fromMidiNote:UInt8) -> UInt8 {
        
        //get in scale note from all notes
        if let inScaleMusicNote:Int = _getInScaleNote(
                ofMusicalNote: Int(fromMidiNote),
                fromScaleNotes: _allNotesInScale
            ) {
            
            //return as a midi note
            return UInt8(inScaleMusicNote)
            
        }
        
        //else return the original
        return fromMidiNote
    }
    
    
    //MARK:- DISPLAY NOTES
    //positive                               0    1     2    3     4    5    6     7    8     9    10    11
    //negative                              -12  -11   -10  -9    -8   -7   -6    -5   -4    -3   -2    -1
    fileprivate let displayKeys:[String] = ["c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"]
    
    //called by midi send
    public func getDisplayKey(fromMidiNote:UInt8) -> String{
        
        //convert and send to other func
        return getDisplayKey(fromMusicalNote: Int(fromMidiNote) )
    }
    
    public func getDisplayKey(fromMusicalNote:Int) -> String {
        
        let zeroBasedMusicalNote:Int = fromMusicalNote - MIDDLE_C
        
        //get octave by dividing note by 12 (number of keys in an octave)
        //and add default octave so 0 would become 4
        var octave:Int = Int(zeroBasedMusicalNote / KEYS_PER_OCTAVE) + DEFAULT_OCTAVE
        
        //get index of display note from reminander of note into octave
        var displayKeyIndex:Int = fromMusicalNote % KEYS_PER_OCTAVE
        
        //if value is negative, add octave to bring it into the 0-12 range
        if (displayKeyIndex < 0){
            displayKeyIndex += KEYS_PER_OCTAVE
            octave -= 1
        }
        
        let displayKey:String = displayKeys[displayKeyIndex]
    
        return displayKey + String(octave)
        
    }
    
    //MARK: - HELPERS
    fileprivate func _getInScaleNote(ofMusicalNote:Int, fromScaleNotes:[Int]) -> Int? {
        
        if (fromScaleNotes.count > 0) {
            
            //check to see if the musical note is in the current scale.
            if let _ = fromScaleNotes.firstIndex(of: ofMusicalNote) {
                
                //If so, return a variant value from the current scale
                if (debug) { print("MNM: Note is in scale") }
                return _getKeyboardSafeNote(fromNote: ofMusicalNote)
                
            } else {
                
                //this can happen with notes coming in from a midi keyboard or drum pads
                //or the user has recorded notes then changed the scale or octave of a track
                
                if (ofMusicalNote < fromScaleNotes[0]){
                    
                    //is the incoming note below the bottom of the scale?
                    
                    let distanceBelowCurrScale:Int = fromScaleNotes[0] - ofMusicalNote
                    let octaveModulo:Int = distanceBelowCurrScale % KEYS_PER_OCTAVE
                    
                    if (debug) { print("MNM: Note", ofMusicalNote, "is", distanceBelowCurrScale, "steps below scale", fromScaleNotes) }
                    
                    //get number of octaves below the current one by dividing the distance below by 12, using integers which round the value down (equivalent of Math.floor)
                    var numberOfOctavesBelow:Int = (distanceBelowCurrScale / KEYS_PER_OCTAVE) + 1
                    
                    //if distance is exactly an octave, substract one from number of octaves to correct the math
                    if (octaveModulo == 0){
                        numberOfOctavesBelow -= 1
                    }
                    
                    //get the equivalent of the note in this octave
                    let noteInOctave:Int = ofMusicalNote + (numberOfOctavesBelow * KEYS_PER_OCTAVE)
                    
                    //attempt to get a nearby index of this note
                    if let nearbyIndex:Int = _getNearbyIndex(ofMusicalNote: noteInOctave, inScale: fromScaleNotes) {
                        
                        if (debug) { print("MNM: Note is", numberOfOctavesBelow, "octaves below scale, move to", noteInOctave, ", quantize to", fromScaleNotes[nearbyIndex]) }
                        return _getKeyboardSafeNote(fromNote: fromScaleNotes[nearbyIndex])
                        
                    } else {
                        
                        print("MNM: Error: Unable to find nearby index from below-scale note.")
                        return nil
                    }
                    
                } else if (ofMusicalNote > fromScaleNotes.last!){
                    
                    //note: OK to force unwrap .last because I make sure the array has conent in the code above
                    
                    //is the incoming note above the top of the scale? similar process
                    
                    let distanceAboveCurrScale:Int = ofMusicalNote - fromScaleNotes.last!
                    let octaveModulo:Int = distanceAboveCurrScale % KEYS_PER_OCTAVE
                    
                    if (debug) { print("MNM: Note", ofMusicalNote," is", distanceAboveCurrScale, "steps above scale", fromScaleNotes) }
                    
                    //get number of octaves above the current one by dividing the distance above by 12, using integers which round the value down (equivalent of Math.floor)
                    var numberOfOctavesAbove:Int = (distanceAboveCurrScale / KEYS_PER_OCTAVE) + 1
                    
                    //if distance is exactly an octave, substract one from number of octaves to correct the math
                    if (octaveModulo == 0){
                        numberOfOctavesAbove -= 1
                    }
                    
                    //get the equivalent of the note in this octave
                    let noteInOctave:Int = ofMusicalNote - (numberOfOctavesAbove * KEYS_PER_OCTAVE)
                    
                    //attempt to get a nearby index of this note
                    if let nearbyIndex:Int = _getNearbyIndex(ofMusicalNote: noteInOctave, inScale: fromScaleNotes) {
                        
                        if (debug) { print("MNM: Note is", numberOfOctavesAbove, "octaves above scale, move to", noteInOctave, ", quantize to", fromScaleNotes[nearbyIndex]) }
                        return _getKeyboardSafeNote(fromNote: fromScaleNotes[nearbyIndex])
                        
                    } else {
                        
                        if (debug) {
                            print("MNM: Error: Unable to find nearby index.")
                        }
                        
                        return nil
                    }
                    
                } else {
                    
                    //the incoming note in the octave, but just not in scale
                    
                    if let nearbyIndex:Int = _getNearbyIndex(ofMusicalNote: ofMusicalNote, inScale: fromScaleNotes) {
                        
                        return _getKeyboardSafeNote(fromNote: fromScaleNotes[nearbyIndex])
                        
                    } else {
                        
                        if (debug) {
                            print("MNM: Error: Unable to find nearby index from in-octave note.")
                        }
                        
                        return nil
                    }
                }
            }
            
        } else {
            
            if (debug) {
                print("MNM: Error: Scale notes of track is empty. Cannot choose variant")
            }
            
            return nil
        }
        
    }
    

    fileprivate func _getArrayOfOctaves(withCenter:Int, withRange:Int) -> [Int] {
        
        var arrayOfOctaves:[Int] = []
        
        //if the range is only 1, return the center (only) range immediately
        if (withRange == 1) {
            
            arrayOfOctaves = [withCenter]
            
        } else {
            // else range is 2 or larger
            
            var octaveCenter:Int = withCenter
            var octaveRange:Int = withRange
            
            //make sure numbers is within the paramaters, error checking
            if (octaveRange > OCTAVE_TOTAL){
                octaveRange = OCTAVE_TOTAL
            }
            
            if (octaveCenter < LOWEST_OCTAVE){
                
                octaveCenter = LOWEST_OCTAVE
                
            } else if (octaveCenter > HIGHEST_OCTAVE) {
                
                octaveCenter = HIGHEST_OCTAVE
            }
            
            
            //define the bottom with different methods, then count up to fill the array
            var rangeBottom:Int
            
            //test edges first
            if (octaveCenter == LOWEST_OCTAVE) {
                
                //start at bottom and range goes up
                rangeBottom = octaveCenter
                arrayOfOctaves = [rangeBottom]
                
                //add octaves, +1 up the scale
                for i in 1..<octaveRange {
                    
                    arrayOfOctaves.append(rangeBottom + i)
                }
                
            } else if (octaveCenter == HIGHEST_OCTAVE){
                
                //start with furthest below center and add up to center
                rangeBottom = octaveCenter - octaveRange
                
                for i in 1...octaveRange {
                    
                    arrayOfOctaves.append(rangeBottom + i)
                }
                
            } else {
                
                //center is not the max or the minimum
                
                //calc bottom with center in the middle
                rangeBottom = octaveCenter - (octaveRange / 2)
                
                //if bottom if below lowest, move range up
                if (rangeBottom < LOWEST_OCTAVE){
                    
                    rangeBottom = LOWEST_OCTAVE
                    
                } else if ((rangeBottom + octaveRange) > (HIGHEST_OCTAVE + 1)){
                    
                    let amountOver:Int = (rangeBottom + octaveRange) - (HIGHEST_OCTAVE + 1)
                    rangeBottom -= amountOver
                }
                
                //populate array
                for i in 0..<octaveRange {
                    
                    arrayOfOctaves.append(rangeBottom + i)
                }
            }
        }
        
        return arrayOfOctaves
    }

    fileprivate func _getScaleNotes(fromOctaveArray:[Int]) -> [Int] {
        
        var scaleNotes:[Int] = []
        
        for octave in fromOctaveArray {
            
            //loop through each position in the current scale
            for position in _currScale {
                
                //position is the slot in a particular scale's pattern
                //major scale example: [0,  2,  4,  5,  7,  9,  11]
                //so position would be 5, or 7
                
                //root key changes the starting point, so if rootkey is 1, then 5 would become 6
                let positionInRootKey:Int = position + _rootKey
                
                //target the base note in the octave
                //for example, octave 4's starting note would be 4 x 12 = 48
                let octaveBaseNote:Int = (octave * KEYS_PER_OCTAVE)
                
                //since the reference point is middle C (60) rather than zero, add that too
                let middleCBase:Int = (MIDDLE_C - (KEYS_PER_OCTAVE * DEFAULT_OCTAVE))
                
                //add them all together
                let noteToAdd:Int = positionInRootKey + octaveBaseNote + middleCBase
                
                //error checking
                if (noteToAdd >= 0 && noteToAdd < KEYS_TOTAL){
                    scaleNotes.append(noteToAdd)
                }
            }
        }
        
        if (debug){
            
            //print out note numbers and display keys, starting with root key
            var displayKeys:[String] = []
            for note in scaleNotes{
                displayKeys.append(getDisplayKey(fromMusicalNote: note))
            }
            
            print("MNM: Scale notes ", scaleNotes)
            print("MNM: Display keys", displayKeys)
            
        }
        
        return scaleNotes
        
    }
    
    fileprivate func _getNearbyIndex(ofMusicalNote:Int, inScale: [Int]) -> Int? {
        
        //look for closest in scale
        let closest = inScale.enumerated().min( by: { abs($0.1 - ofMusicalNote) < abs($1.1 - ofMusicalNote) } )!
        
        //get note (element of closest)
        let closestNote:Int = closest.element
        
        //get index of this note in the scale
        if let noteIndex = inScale.firstIndex(of: closestNote) {
            return noteIndex
        } else {
            return nil
        }
    }
    
    fileprivate func _setMusicalScale(withScaleID:String){
        
        //apply user pref to scale
        
        switch withScaleID {
            
        case MusicScale.MAJOR:
            _currScale = majorScale
            
        case MusicScale.MINOR:
            _currScale = minorScale
            
        case MusicScale.DORIAN:
            _currScale = dorianScale
            
        case MusicScale.PHRYGIAN:
            _currScale = phrygianScale
        
        case MusicScale.LYDIAN:
            _currScale = lydianScale
            
        case MusicScale.MIXOLYDIAN:
            _currScale = mixolydianScale
            
        case MusicScale.AEOLIAN:
            _currScale = aeolianScale
            
        case MusicScale.LOCARIAN:
            _currScale = locrianScale
            
        case MusicScale.MAJOR_BLUES:
            _currScale = majorBluesScale
            
        case MusicScale.MINOR_BLUES:
            _currScale = minorBluesScale
            
        case MusicScale.MAJOR_PENTATONIC:
            _currScale = majorPentatonicScale
            
        case MusicScale.MINOR_PENTATONIC:
            _currScale = minorPentatonicScale
            
        case MusicScale.DIMINISHED:
            _currScale = diminishedScale
            
        case MusicScale.CHROMATIC:
            _currScale = chromaticScale
            
        case MusicScale.HARMONIC_MINOR:
            _currScale = harmonicMinorScale
            
        case MusicScale.WHOLE_TONE:
            _currScale = wholeToneScale
            
        default:
            
            //print error
            print("MNM: Error: Unrecognized scale ID when trying to during setMusicalScale(withScaleID. Using Major scale as default")
            //major scale is the default
            _currScale = majorScale
            
        }
        
        if (debug){ print("MNM: Curr scale is now", _currScale) }
    
    }
    
    fileprivate func _getKeyboardSafeNote(fromNote:Int) -> Int{
        
        if (fromNote >= KEYS_TOTAL) {
            return KEYS_TOTAL - 1
        
        } else if (fromNote < 0) {
            return 0
            
        } else {
            return fromNote
        }
    }
}
