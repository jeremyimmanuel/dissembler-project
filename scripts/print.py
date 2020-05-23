
def printSourceRegUtil():
    sr = 'MOVE_UTIL_SOURCE_REG_'
    for i in range(8):
        print(f'{sr}{i}')
        print(f'\tJSR DISP_STR_{i}')
        print('\tBRA CHECK_DES_MODE')
        print()
def printUtils(utilString: str):
    for i in range(8):
        print(f'{utilString}{i}')
        print(f'\tJSR DISP_STR_{i}')
        print('\tBRA DONE')

def printCheckCompare(s: str):
    sr = 'MOVE_UTIL_DES_REG_'
    for i in range(8):
        print(f'CMP.B #{i}, D4')
        print(f'BEQ MOVE_UTIL_DES_REG_{i}')


if __name__ == "__main__":
    # printSourceRegUtil()
    # printCheckCompare('s')
    printUtils('MOVE_UTIL_DES_REG_')